<template>
  <div class="content">
    <div class="container">
      <div class="Search__container">
        <fieldset>
          <div class="field">
            <label for="search">Npm package name</label>
            <input
              class="Search__input"
              @keyup.enter="requestData"
              placeholder="npm package name"
              type="search" id="search"
              v-model="packageSearchText"
            >
          </div>

          <div class="field">
            <label for="start-date">Start date</label>
            <datepicker placeholder="Start date" v-model="periodStart" id="start-date"></datepicker>
          </div>

          <div class="field">
            <label for="end-date">End date</label>
            <datepicker placeholder="End date" v-model="periodEnd" id="end-date"></datepicker>
          </div>
          <button class="Search__button" @click="requestData">Find</button>
        </fieldset>
      </div>
      <div class="error-message" v-if="showError">
        {{errorMessage}}
      </div>
      <hr>
      <h1 class="title" v-if="loaded">{{ packageName }}</h1>
      <div class="Chart__container" v-if="loaded">
        <div class="Chart__title">
          Downloads per Day <span>{{ period }}</span>
          <hr>
        </div>
        <div class="Chart__content">
          <LineChart v-if="loaded" :chart-data="downloads" :chart-labels="labels"></LineChart>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import moment from 'moment'
import Datepicker from 'vuejs-datepicker'
import LineChart from '@/components/LineChart'

export default {
  components: {
    LineChart,
    Datepicker
  },
  props: {},
  data () {
    return {
      packageSearchText: 'vue',
      packageName: '',
      loaded: false,
      downloads: [],
      labels: [],
      showError: false,
      errorMessage: 'Please enter a package name',
      periodStart: '',
      periodEnd: new Date()
    }
  },
  mounted () {
    if (this.$route && this.$route.params && this.$route.params.package) {
      this.packageSearchText = this.$route.params.package
    }
    this.requestData()
  },
  computed: {
    _endDate () {
      return moment(this.periodEnd).format('YYYY-MM-DD')
    },
    _startDate () {
      return moment(this.periodStart).format('YYYY-MM-DD')
    },
    period () {
      return this.periodStart
        ? `${this._startDate}:${this._endDate}`
        : 'last-month'
    }
  },
  methods: {
    requestData () {
      this.resetState()
      if (this.packageSearchText === null ||
          this.package === '' ||
          this.package === 'undefined'
      ) {
        this.showError = true
        return
      }
      axios.get(`https://api.npmjs.org/downloads/range/${this.period}/${this.packageSearchText}`)
        .then(response => {
          console.log(response.data)
          this.downloads = response.data.downloads.map(download => download.downloads)
          this.labels = response.data.downloads.map(download => download.day)
          this.packageName = response.data.package
          this.setURL()
          this.loaded = true
        })
        .catch(err => {
          this.errorMessage = err.response.data.error
          this.showError = true
        })
    },
    resetState () {
      this.loaded = false
      this.showError = false
    },
    setURL () {
      history.pushState(
        {info: `npm-stats ${this.packageSearchText}`},
        this.packageSearchText,
        `/#/${this.packageSearchText}`
      )
    }
  }
}
</script>

<style scoped>
  fieldset {
    border: none;
    display: flex;
    align-items: center;
  }
  .field {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
  }
  .Search__button {
    /*padding: 1ch;*/
  }
</style>
