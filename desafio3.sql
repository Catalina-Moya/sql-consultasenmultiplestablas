    -- creamos la base de datos

    CREATE DATABASE desafio3_Catalina_Moya_549;

    -- creamos la tabla

    CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100),
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    rol VARCHAR(50)
);

    -- insertamos los datos 

    INSERT INTO usuarios (email, nombre, apellido, rol) VALUES 
    ('rosarojas@gmail.com', 'Rosa', 'Rojas', 'administrador'),
    ('claralopez@gmail.com', 'Clara', 'López', 'usuario'),
    ('sergioruiz@gmail.com', 'Sergio', 'Ruiz', 'usuario'),
    ('adrianadiaz@gmail.com', 'Adriana', 'Díaz', 'usuario'),
    ('pedrotorres@gmail.com', 'Pedro', 'Torres', 'usuario');

    -- creamos la tabla

    CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(100),
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

    -- insertamos los datos 

    INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
    ('Post 1', 'Contenido del Post 1', '2013-03-15', '2022-09-07', TRUE, 1),
    ('Post 2', 'Contenido del Post 2', '2010-05-30', '2023-01-15', FALSE, 1),
    ('Post 3', 'Contenido del Post 3', '2019-10-29', '2022-02-18', TRUE, 2),
    ('Post 4', 'Contenido del Post 4', '2021-03-09', '2024-01-23', FALSE, 2),
    ('Post 5', 'Contenido del Post 5', '2020-09-04', '2023-05-23', TRUE, NULL);

    -- creamos la tabla

    CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT,
    fecha_creacion TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

    -- insertamos los datos 

    INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
    ('Comentario 1', '2021-09-13', 1, 1),
    ('Comentario 2', '2022-03-15', 2, 1),
    ('Comentario 3', '2022-03-15', 3, 1),
    ('Comentario 4', '2020-08-08', 1, 2),
    ('Comentario 5', '2022-05-20', 2, 2);



    -- 2) Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.

    SELECT u.nombre, u.email, p.titulo, p.contenido FROM usuarios u INNER JOIN posts p ON u.id = p.usuario_id;

    -- 3) Muestra el id, título y contenido de los posts de los administradores.

    SELECT p.id, p.titulo, p.contenido FROM posts p INNER JOIN usuarios u ON p.usuario_id = u.id WHERE u.rol = 'administrador';

    -- 4) Cuenta la cantidad de posts de cada usuario.

    SELECT u.id, u.email, COUNT(p.id) AS cantidad_de_posts FROM usuarios u LEFT JOIN posts p ON u.id = p.usuario_id GROUP BY u.id, u.email;

    -- 5)  Muestra el email del usuario que ha creado más posts.

    SELECT u.email FROM usuarios u JOIN posts p ON u.id = p.usuario_id GROUP BY u.id ORDER BY COUNT(p.id) DESC LIMIT 1;

    -- 6) Muestra la fecha del último post de cada usuario.

    SELECT u.id, u.email, MAX(p.fecha_creacion) AS ultimo_post FROM usuarios u LEFT JOIN posts p ON u.id = p.usuario_id GROUP BY u.id, u.email;

    -- 7) Muestra el título y contenido del post (artículo) con más comentarios.

    SELECT p.titulo, p.contenido FROM posts p JOIN comentarios c ON p.id = c.post_id GROUP BY p.id ORDER BY COUNT(c.id) DESC LIMIT 1;

    -- 8) Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

    SELECT p.titulo, p.contenido AS post_contenido, c.contenido AS comentario_contenido, u.email FROM posts p JOIN comentarios c ON p.id = c.post_id JOIN usuarios u ON c.usuario_id = u.id;

    -- 9) Muestra el contenido del último comentario de cada usuario.

    SELECT u.email, c.contenido AS ultimo_comentario FROM usuarios u JOIN comentarios c ON u.id = c.usuario_id WHERE c.id = (
    SELECT MAX(id)
    FROM comentarios
    WHERE usuario_id = u.id) ORDER BY u.email;

    -- 10) Muestra los emails de los usuarios que no han escrito ningún comentario

    SELECT u.email FROM usuarios u LEFT JOIN comentarios c ON u.id = c.usuario_id WHERE c.id IS NULL;