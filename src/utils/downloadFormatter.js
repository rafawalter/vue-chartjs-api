import {dateToYear} from './dateFormatter'

export function removeDuplicate (array, element) {
  if (array.indexOf(element) < 0) {
    array.push(element)
  }
  return array
}

export const getDownloadsPerYear = (data) => {
  return data.reduce((date, current) => {
    if (date.indexOf(dateToYear(current.day)) < 0) {
      date.push(dateToYear(current.day))
    }
    return date
  }, [])
    .map((date) => {
      return {
        date: date,
        downloads: data.filter(el => dateToYear(el.day) === date)
          .map(el => el.downloads)
          .reduce((total, download) => total + download)
      }
    })
    .map(element => element.downloads)
}
