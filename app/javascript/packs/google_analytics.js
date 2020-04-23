document.addEventListener('turbolinks:load', function (event) {
  //   if (typeof gtag === 'function') {
  //     gtag('config', '<%= Rails.application.credentials.dig(:google_analytics) %>', {
  //       'page_location': event.data.url
  //     })
  //   }
  // })

  if (typeof firebase === 'object') {
    console.log('Logging page to Firebase');
    // TODO: Completar configuracion
    firebase.analytics().setCurrentScreen('WEB');
    firebase.analytics().logEvent('screen_view', {
      screen_name: "Web Nav Event"
    })
  }
})