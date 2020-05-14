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
            <datepicker input-class="Search__input" placeholder="Start date" v-model="periodStart" id="start-date"
                        name="start-date" v-on:selected="validateDataRequest()"></datepicker>
          </div>

          <div class="field">
            <label for="end-date">End date</label>
            <datepicker input-class="Search__input" placeholder="End date" v-model="periodEnd" id="end-date"
                        name="end-date" v-on:selected="validateDataRequest()"></datepicker>
          </div>

          <button class="Search__button" @click="requestData">Find</button>

        </fieldset>
      </div>

      <div class="error-message" v-if="showError">
        {{errorMessage}}
      </div>

      <div v-if="loading" class="loading">
        🔧 Building Charts ...
        <div class="sk-cube-grid">
          <div class="sk-cube sk-cube1"></div>
          <div class="sk-cube sk-cube2"></div>
          <div class="sk-cube sk-cube3"></div>
          <div class="sk-cube sk-cube4"></div>
          <div class="sk-cube sk-cube5"></div>
          <div class="sk-cube sk-cube6"></div>
          <div class="sk-cube sk-cube7"></div>
          <div class="sk-cube sk-cube8"></div>
          <div class="sk-cube sk-cube9"></div>
        </div>
      </div>

      <h1 class="title" v-if="loaded">{{ packageName }}</h1>

      <div class="Chart__container" v-if="loaded">
        <div class="Chart__title">
          Downloads per Day <span>{{ formattedPeriod }}</span>
          <hr>
        </div>
        <div class="Chart__content">
          <LineChart v-if="loaded" :chart-data="downloads" :chart-labels="labels"></LineChart>
        </div>
      </div>

      <div class="Chart__container" v-if="loaded">
        <div class="Chart__title">
          Downloads per Week <span>{{ formattedPeriod }}</span>
          <hr>
        </div>
        <div class="Chart__content">
          <LineChart v-if="loaded" :chart-data="downloadsWeek" :chart-labels="labelsWeek"></LineChart>
        </div>
      </div>

      <div class="Chart__container" v-if="loaded">
        <div class="Chart__title">
          Downloads per Month <span>{{ formattedPeriod }}</span>
          <hr>
        </div>
        <div class="Chart__content">
          <LineChart v-if="loaded" :chart-data="downloadsMonth" :chart-labels="labelsMonth"></LineChart>
        </div>
      </div>

      <div class="Chart__container" v-if="loaded">
        <div class="Chart__title">
          Downloads per Year <span>{{ formattedPeriod }}</span>
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
import {dateToDay, dateBeautify, dateToYear, dateToMonth, dateToWeek} from '../utils/dateFormatter'
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
      loading: false,
      loaded: false,
      downloads: [],
      labels: [],
      downloadsWeek: [],
      labelsWeek: [],
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
      this.loading = true
      axios.get(`https://api.npmjs.org/downloads/range/${this.period}/${this.packageSearchText}`)
        .then(response => {
          this.rawData = response.data.downloads
          this.downloads = response.data.downloads.map(entry => entry.downloads)
          this.labels = response.data.downloads.map(entry => entry.day)
          this.packageName = response.data.package
          this.totalDownloads = this.downloads.reduce((total, download) => total + download)
          this.setURL()
          this.loaded = true
          this.formatWeek()
          this.formatMonth()
          this.formatYear()
          this.loading = false
        })
        .catch(err => {
          // this.errorMessage = err.response.data.error
          this.errorMessage = err.response
          this.showError = true
          this.loading = false
        })
    },
    validateDataRequest () {
      console.log('ValidateData')
      if (this.packageName !== '' && this.periodStart !== '') {
        this.requestData()
      }
    },
    formatWeek () {
      this.labelsWeek = this.rawData
        .map(entry => dateToWeek(entry.day))
        .reduce(removeDuplicate, [])
      this.downloadsWeek = groupData(this.rawData, dateToWeek)
    },
    formatMonth () {
      this.labelsMonth = this.rawData
        .map(entry => dateToMonth(entry.day))
        .reduce(removeDuplicate, [])
      this.downloadsMonth = groupData(this.rawData, dateToMonth)
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

<style lang="scss">
  fieldset {
    border: none;
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    align-items: flex-end;
  }

  fieldset > * {
    margin: 1ch;
  }

  .field {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
  }

  @import "../assets/styles/_variables.scss";
  hr {
    display: block;
    height: 1px;
    border: 0;
    border-top: 1px solid color(solitude);
    margin: 1em 0;
    padding: 0;
  }

  .content {
    background: color(ghost-white);
    min-height: calc(100vh - 180px);
  }

  .title {
    text-align: center;
    color: color(fjord);
  }

  .container {
    @include container();
  }

  .loading {
    text-align: center;
    color: color(fjord);
    font-size: rem(18);
  }

  .error-message {
    text-align: center;
    color: color(robin-egg-blue);
  }

  .Search {
    @include has(container) {
      max-width: rem(640);
      padding: rem(100) 0 rem(20) 0;
      margin: 0 auto;
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
    }
    @include has(input) {
      padding: rem(20);
      background-color: #fff;
      border: 1px solid color(solitude);
      font-size: rem(16);
      flex: 1;
    }
    @include has(button) {
      appearance: none;
      padding: rem(18) rem(45);
      margin-left: rem(20);
      border: 0;
      border-radius: 0;
      cursor: pointer;
      text-align: center;
      font-size: rem(21);
      font-weight: 600;
      color: #fff;
      background: color(robin-egg-blue);
      @include hover-active-states {
        background: darken(color(robin-egg-blue), 10%);
      }
    }
    @include has(icon) {
      width: rem(40);
      height: rem(40);
      margin-left: rem(15);
      cursor: pointer;
      color: color(fjord);
      @include hover-active-states {
        color: color(robin-egg-blue);
      }
      > svg {
        fill: currentColor;
      }
    }
    @include has(settings) {
      max-width: rem(640);
      margin: 0 auto;
      padding: rem(20) 0;
      display: flex;
      flex-direction: row;
      justify-content: center;
      .vdp-datepicker + .vdp-datepicker {
        margin-left: 1.25rem;
        flex: 1;
      }
    }
  }

  .Chart__container {
    border-radius: $base-border-radius;
    background-color: #fff;
    box-shadow: 0 2px 16px 0 rgba(0, 0, 0, 0.30);
    padding: rem(20) rem(40);
    margin: rem(50) 0;
  }

  .Chart__title {
    color: color(fjord);
    margin-bottom: rem(40);
    font-weight: 600;
    font-size: rem(16);

    > span {
      font-weight: 400;
      color: color(robin-egg-blue);
      font-size: rem(16);
      margin-left: rem(25);
    }
  }

  .sk-cube-grid {
    width: 40px;
    height: 40px;
    margin: 100px auto;
  }

  .sk-cube-grid .sk-cube {
    width: 33%;
    height: 33%;
    background-color: color(robin-egg-blue);
    float: left;
    -webkit-animation: sk-cubeGridScaleDelay 1.3s infinite ease-in-out;
    animation: sk-cubeGridScaleDelay 1.3s infinite ease-in-out;
  }

  .sk-cube-grid .sk-cube1 {
    -webkit-animation-delay: 0.2s;
    animation-delay: 0.2s;
  }

  .sk-cube-grid .sk-cube2 {
    -webkit-animation-delay: 0.3s;
    animation-delay: 0.3s;
  }

  .sk-cube-grid .sk-cube3 {
    -webkit-animation-delay: 0.4s;
    animation-delay: 0.4s;
  }

  .sk-cube-grid .sk-cube4 {
    -webkit-animation-delay: 0.1s;
    animation-delay: 0.1s;
  }

  .sk-cube-grid .sk-cube5 {
    -webkit-animation-delay: 0.2s;
    animation-delay: 0.2s;
  }

  .sk-cube-grid .sk-cube6 {
    -webkit-animation-delay: 0.3s;
    animation-delay: 0.3s;
  }

  .sk-cube-grid .sk-cube7 {
    -webkit-animation-delay: 0s;
    animation-delay: 0s;
  }

  .sk-cube-grid .sk-cube8 {
    -webkit-animation-delay: 0.1s;
    animation-delay: 0.1s;
  }

  .sk-cube-grid .sk-cube9 {
    -webkit-animation-delay: 0.2s;
    animation-delay: 0.2s;
  }

  @-webkit-keyframes sk-cubeGridScaleDelay {
    0%, 70%, 100% {
      -webkit-transform: scale3D(1, 1, 1);
      transform: scale3D(1, 1, 1);
    }
    35% {
      -webkit-transform: scale3D(0, 0, 1);
      transform: scale3D(0, 0, 1);
    }
  }

  @keyframes sk-cubeGridScaleDelay {
    0%, 70%, 100% {
      -webkit-transform: scale3D(1, 1, 1);
      transform: scale3D(1, 1, 1);
    }
    35% {
      -webkit-transform: scale3D(0, 0, 1);
      transform: scale3D(0, 0, 1);
    }
  }
</style>
