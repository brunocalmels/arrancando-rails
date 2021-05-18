# ARRANCANDO

Arrancando es una app para apasionados por la comida. Es una comunidad donde podés aprender y compartir, publicaciones, recetas, técnicas, tips, culturas culinarias de más de 20 países. En Arrancando también podés crear tu tienda virtual gratis para promocionar tus productos.

## To do
### Performance improvements

- [ ] Analizar N+1 con Scout APM y eliminarlas
- [ ] Considerar *processed* para avatars de usuarios
- [ ] Paginar comentarios de los show, o no enviar los avatares de cada usuario. Cada comentario implica varias queries a la DB.
- [ ] Estudiar
- [x] Utilizar *with_attached_images* (https://stackoverflow.com/questions/57357892/rails-reducing-the-amount-of-activestorage-queries)