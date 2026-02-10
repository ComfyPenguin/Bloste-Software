-- Insert Categories
INSERT INTO categoria (id, nombre, descripcion) VALUES 
(1, 'Tecnología', 'Contenido relacionado con tecnología e informática'),
(2, 'Deportes', 'Videos de diferentes deportes y actividades físicas'),
(3, 'Música', 'Contenido musical, tutoriales y performances'),
(4, 'Educación', 'Cursos, tutoriales educativos y formación')
ON DUPLICATE KEY UPDATE nombre=nombre;

-- Insert Videos
INSERT INTO videos (id, titulo, autor, descripcion, duracion, idVideo, fecha_subida, visible) VALUES 
(1, 'Introducción a Java', 'Juan García', 'Tutorial completo sobre los fundamentos de Java', 3600, 'https://example.com/java-intro', CURDATE() - INTERVAL 60 DAY, true),
(2, 'Entrenamiento de Fútbol', 'Carlos López', 'Ejercicios de entrenamiento para futbolistas profesionales', 1800, 'https://example.com/futbol-training', CURDATE() - INTERVAL 30 DAY, true),
(3, 'Guitarra Básica', 'María Rodríguez', 'Aprende lo básico de la guitarra desde cero', 2400, 'https://example.com/guitarra-basica', 'https://example.com/images/guitarra.jpg', CURDATE() - INTERVAL 21 DAY, true),
(4, 'Spring Boot Avanzado', 'Pedro Martínez', 'Conceptos avanzados de Spring Boot para aplicaciones empresariales', 5400, 'https://example.com/spring-avanzado', CURDATE() - INTERVAL 7 DAY, true)
ON DUPLICATE KEY UPDATE titulo=titulo;

-- Link Videos to Categories
INSERT INTO video_categoria (categoria_id, video_id) VALUES 
(1, 1), -- Java -> Tecnología
(4, 1), -- Java -> Educación
(2, 2), -- Fútbol -> Deportes
(3, 3), -- Guitarra -> Música
(4, 3), -- Guitarra -> Educación
(1, 4), -- Spring Boot -> Tecnología
(4, 4)  -- Spring Boot -> Educación
ON DUPLICATE KEY UPDATE categoria_id=categoria_id;
