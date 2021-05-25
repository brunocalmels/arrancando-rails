# ARRANCANDO

Arrancando es una app para apasionados por la comida. Es una comunidad donde podés aprender y compartir, publicaciones, recetas, técnicas, tips, culturas culinarias de más de 20 países. En Arrancando también podés crear tu tienda virtual gratis para promocionar tus productos.

## To do
### Performance improvements

- [ ] Considerar cache de fragmentos de vistas (comentarios, x ej, q se renderizan mucho).
- [ ] Encolar (queue) todos los envíos de notificaciones de FCM (NotificacionesHelper::notificar_seguidores, x ej).
- [ ] Analizar N+1 con Scout APM y eliminarlas
- [ ] *app/models/ciudad.rb in nombre_con_provincia at line 50* gran N+1. Llamado desde *app/views/users/_form.html.erb:44*.
- [ ] Considerar *processed* para avatars de usuarios
- [ ] Paginar comentarios de los show, o no enviar los avatares de cada usuario. Cada comentario implica varias queries a la DB.
- [ ] Analizar PG Outliers (https://github.com/heroku/heroku-pg-extras)
- [x] Utilizar *with_attached_images* (https://stackoverflow.com/questions/57357892/rails-reducing-the-amount-of-activestorage-queries)