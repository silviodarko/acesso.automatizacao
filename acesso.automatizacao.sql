# Projeto de Criação de Índices, Views, Permissões e Gatilhos em Banco de Dados

Este projeto consiste na criação de índices, views, permissões e gatilhos em um banco de dados. O objetivo é otimizar as consultas, personalizar os acessos às informações por meio de views e garantir a integridade dos dados com o uso de gatilhos.

## Código SQL Completo

Aqui está o código SQL completo para o projeto:

```sql
-- Parte 1 - Personalizando acessos com views

-- Número de empregados por departamento e localidade
CREATE VIEW view_employees_per_department_location AS
SELECT d.department_name, l.location_name, COUNT(*) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
GROUP BY d.department_name, l.location_name;

-- Lista de departamentos e seus gerentes
CREATE VIEW view_departments_and_managers AS
SELECT d.department_name, m.manager_name
FROM departments d
JOIN managers m ON d.manager_id = m.manager_id;

-- Projetos com maior número de empregados (ordenados por ordem decrescente)
CREATE VIEW view_projects_with_most_employees AS
SELECT p.project_name, COUNT(*) AS total_employees
FROM projects p
JOIN employees_projects ep ON p.project_id = ep.project_id
GROUP BY p.project_name
ORDER BY total_employees DESC;

-- Lista de projetos, departamentos e gerentes
CREATE VIEW view_projects_departments_managers AS
SELECT p.project_name, d.department_name, m.manager_name
FROM projects p
JOIN departments d ON p.department_id = d.department_id
JOIN managers m ON d.manager_id = m.manager_id;

-- Quais empregados possuem dependentes e se são gerentes
CREATE VIEW view_employees_with_dependents AS
SELECT e.employee_name, d.dependent_name, CASE WHEN e.is_manager = 1 THEN 'Sim' ELSE 'Não' END AS is_manager
FROM employees e
JOIN dependents d ON e.employee_id = d.employee_id;


-- Parte 2 - Criando gatilhos para cenário de e-commerce

-- Gatilho de remoção (before delete)
CREATE TRIGGER before_delete_user
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    INSERT INTO deleted_users (user_id, user_name, deleted_at)
    VALUES (OLD.user_id, OLD.user_name, NOW());
END;

-- Gatilho de atualização (before update)
CREATE TRIGGER before_update_employee
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END;

