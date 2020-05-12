<template>
  <header>
      <img class='logo' src="../assets/logo.png">
      Vue, ChartJs and API
  </header>
</template>

<script>
export default {
  name: 'Header'
}
</script>

<style scoped>
  header {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    margin: 0;
  }
  .logo {
    width: 1em;
  }
</style>
