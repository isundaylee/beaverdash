APP_CONFIG ||= {}
APP_CONFIG = APP_CONFIG.deep_merge({
  yo: {
    api_key: 'YO_API_KEY'
  },
  fitbit: {
    key: 'FITBIT_KEY',
    secret: 'FITBIT_SECRET'
  }
})
