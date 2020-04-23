document.addEventListener('turbolinks:load', function (event) {
  //   if (typeof gtag === 'function') {
  //     gtag('config', '<%= Rails.application.credentials.dig(:google_analytics) %>', {
  //       'page_location': event.data.url
  //     })
  //   }
  // })
  console.log('FB Anlytics: Afuera');

  if (typeof firebase === 'function') {
    console.log('FB Anlytics: Adentro');
    firebase.analytics.logEvent('page_view', {
      page_name: "Web Home"
    })
  }
})