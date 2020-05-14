export function removeDuplicate (array, element) {
  if (array.indexOf(element) < 0) {
    array.push(element)
  }
  return array
}

export const groupData = (data, dateFormatter) => {
  return data.reduce((date, current) => {
    if (date.indexOf(dateFormatter(current.day)) < 0) {
      date.push(dateFormatter(current.day))
    }
    return date
  }, [])
    .map((date) => {
      return {
        date: date,
        downloads: data.filter(el => dateFormatter(el.day) === date)
          .map(el => el.downloads)
          .reduce((total, download) => total + download)
      }
    })
    .map(element => element.downloads)
}
