SELECT publicaciones.id, avg, cant_punt, coms
from publicaciones LEFT JOIN 
  (
    SELECT id, avg(value::FLOAT), count(*) as cant_punt
    FROM "publicaciones" LEFT JOIN jsonb_each(puntajes) d
    ON true GROUP BY "publicaciones"."id"
  ) complex ON publicaciones.id = complex.id
  LEFT JOIN (
    SELECT publicacion_id, count(*) AS coms
    FROM comentario_publicaciones
    GROUP BY publicacion_id
  ) comms_pub ON publicaciones.id = comms_pub.publicacion_id
ORDER BY avg DESC nulls LAST, cant_punt DESC nulls LAST, coms DESC nulls LAST;