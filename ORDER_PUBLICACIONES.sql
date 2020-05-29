SELECT publicaciones.id, avg, coms
from publicaciones LEFT JOIN 
  (
    SELECT id, avg(value::FLOAT)
    FROM "publicaciones" LEFT JOIN jsonb_each(puntajes) d
    ON true GROUP BY "publicaciones"."id"
  ) complex ON publicaciones.id = complex.id
  LEFT JOIN (
    SELECT publicacion_id, count(*) AS coms
    FROM comentario_publicaciones
    GROUP BY publicacion_id
  ) comms_pub ON publicaciones.id = comms_pub.publicacion_id
ORDER BY avg DESC nulls LAST, coms DESC nulls LAST