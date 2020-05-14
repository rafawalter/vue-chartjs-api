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
          <span class="Search__icon" @click="toggleSettings()">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 54 54" enable-background="new 0 0 54 54"><path
            d="M51.22 21h-5.052c-.812 0-1.481-.447-1.792-1.197s-.153-1.54.42-2.114l3.572-3.571c.525-.525.814-1.224.814-1.966 0-.743-.289-1.441-.814-1.967l-4.553-4.553c-1.05-1.05-2.881-1.052-3.933 0l-3.571 3.571c-.574.573-1.366.733-2.114.421-.75-.311-1.197-.98-1.197-1.792v-5.052c0-1.533-1.247-2.78-2.78-2.78h-6.44c-1.533 0-2.78 1.247-2.78 2.78v5.052c0 .812-.447 1.481-1.197 1.792-.748.313-1.54.152-2.114-.421l-3.571-3.571c-1.052-1.052-2.883-1.05-3.933 0l-4.553 4.553c-.525.525-.814 1.224-.814 1.967 0 .742.289 1.44.814 1.966l3.572 3.571c.573.574.73 1.364.42 2.114s-.98 1.197-1.792 1.197h-5.052c-1.533 0-2.78 1.247-2.78 2.78v6.439c0 1.534 1.247 2.781 2.78 2.781h5.052c.812 0 1.481.447 1.792 1.197s.153 1.54-.42 2.114l-3.572 3.571c-.525.525-.814 1.224-.814 1.966 0 .743.289 1.441.814 1.967l4.553 4.553c1.051 1.051 2.881 1.053 3.933 0l3.571-3.572c.574-.573 1.363-.731 2.114-.42.75.311 1.197.98 1.197 1.792v5.052c0 1.533 1.247 2.78 2.78 2.78h6.439c1.533 0 2.78-1.247 2.78-2.78v-5.052c0-.812.447-1.481 1.197-1.792.751-.312 1.54-.153 2.114.42l3.571 3.572c1.052 1.052 2.883 1.05 3.933 0l4.553-4.553c.525-.525.814-1.224.814-1.967 0-.742-.289-1.44-.814-1.966l-3.572-3.571c-.573-.574-.73-1.364-.42-2.114s.981-1.197 1.793-1.197h5.052c1.533 0 2.78-1.247 2.78-2.78v-6.44c0-1.533-1.247-2.78-2.78-2.78zm.78 9.22c0 .43-.35.78-.78.78h-5.052c-1.624 0-3.019.932-3.64 2.432-.622 1.5-.295 3.146.854 4.294l3.572 3.571c.305.305.305.8 0 1.104l-4.553 4.553c-.304.304-.799.306-1.104 0l-3.571-3.572c-1.149-1.149-2.794-1.474-4.294-.854-1.5.621-2.432 2.016-2.432 3.64v5.052c0 .43-.35.78-.78.78h-6.44c-.43 0-.78-.35-.78-.78v-5.052c0-1.624-.932-3.019-2.432-3.64-.503-.209-1.021-.311-1.533-.311-1.014 0-1.997.4-2.761 1.164l-3.571 3.572c-.306.306-.801.304-1.104 0l-4.553-4.553c-.305-.305-.305-.8 0-1.104l3.572-3.571c1.148-1.148 1.476-2.794.854-4.294-.621-1.499-2.016-2.431-3.64-2.431h-5.052c-.43 0-.78-.35-.78-.78v-6.44c0-.43.35-.78.78-.78h5.052c1.624 0 3.019-.932 3.64-2.432.622-1.5.295-3.146-.854-4.294l-3.572-3.571c-.305-.305-.305-.8 0-1.104l4.553-4.553c.304-.305.799-.305 1.104 0l3.571 3.571c1.147 1.147 2.792 1.476 4.294.854 1.5-.62 2.432-2.015 2.432-3.639v-5.052c0-.43.35-.78.78-.78h6.439c.431 0 .781.35.781.78v5.052c0 1.624.932 3.019 2.432 3.64 1.502.622 3.146.294 4.294-.854l3.571-3.571c.306-.305.801-.305 1.104 0l4.553 4.553c.305.305.305.8 0 1.104l-3.572 3.571c-1.148 1.148-1.476 2.794-.854 4.294.621 1.5 2.016 2.432 3.64 2.432h5.052c.43-.001.78.349.78.779v6.44zM27 18c-4.963 0-9 4.037-9 9s4.037 9 9 9 9-4.037 9-9-4.037-9-9-9zm0 16c-3.859 0-7-3.141-7-7s3.141-7 7-7 7 3.141 7 7-3.141 7-7 7z"/></svg>
        </span>
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

      <div class="Chart__container" v-if="loaded">
        <div class="Chart__title">
          Downloads per Year <span>{{ period }}</span>
          <hr>
        </div>
        <div class="Chart__content">
          <LineChart v-if="loaded" :chart-data="downloadsYear" :chart-labels="labelsYear"></LineChart>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Datepicker from 'vuejs-datepicker'
import {dateToDay, dateBeautify, dateToYear, dateToMonth} from '../utils/dateFormatter'
import {groupData, removeDuplicate} from '../utils/downloadFormatter'
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
      downloadsMonth: [],
      labelsMonth: [],
      downloadsYear: [],
      labelsYear: [],
      showError: false,
      showSettings: false,
      errorMessage: 'Please enter a package name',
      periodStart: '',
      periodEnd: new Date(),
      rawData: '',
      totalDownloads: ''
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
      return dateToDay(this.periodEnd)
    },
    _startDate () {
      return dateToDay(this.periodStart)
    },
    period () {
      return this.periodStart
        ? `${this._startDate}:${this._endDate}`
        : 'last-year'
    },
    formattedPeriod () {
      return this.periodStart
        ? `${dateBeautify(this._startDate)} - ${dateBeautify(this._endDate)}` : 'last-month'
    }
  },
  methods: {
    resetState () {
      this.loaded = false
      this.showError = false
    },
    requestData () {
      if (this.packageSearchText === null ||
          this.packageSearchText === '' ||
          this.packageSearchText === 'undefined'
      ) {
        this.showError = true
        return
      }
      this.resetState()
      axios.get(`https://api.npmjs.org/downloads/range/${this.period}/${this.packageSearchText}`)
        .then(response => {
          this.rawData = response.data.downloads
          this.downloads = response.data.downloads.map(entry => entry.downloads)
          this.labels = response.data.downloads.map(entry => entry.day)
          this.packageName = response.data.package
          this.totalDownloads = this.downloads.reduce((total, download) => total + download)
          this.setURL()
          this.loaded = true
          this.formatMonth()
          this.formatYear()
        })
        .catch(err => {
          // this.errorMessage = err.response.data.error
          this.errorMessage = err.response
          this.showError = true
        })
    },
    formatMonth () {
      this.labelsMonth = this.rawData
        .map(entry => dateToMonth(entry.day))
        .reduce(removeDuplicate, [])
      this.downloadsYear = groupData(this.rawData, dateToMonth)
    },
    formatYear () {
      this.labelsYear = this.rawData
        .map(entry => dateToYear(entry.day))
        .reduce(removeDuplicate, [])
      this.downloadsYear = groupData(this.rawData, dateToYear)
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
