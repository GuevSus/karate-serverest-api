Feature: POST /usuarios - Registrar nuevos usuarios en el sistema

    Background:
        * url baseUrl
        * path 'usuarios'
        * def testData = call read('classpath:karate/helpers/testData.js')

    @smoke @happy-path  
    Scenario: Registrar un nuevo usuario administrador exitosamente
        And request testData.adminUser
        When method POST
        Then status 201
        And match response.message == "Cadastro realizado com sucesso"
        And match response._id == '#string'

    @happy-path
    Scenario: Registrar un nuevo usuario regular (no administrador) exitosamente
        And request testData.normalUser
        When method POST
        Then status 201
        And match response.message == "Cadastro realizado com sucesso"
    
    @negative
    Scenario: Error al intentar registrar un usuario con email que ya existe en el sistema
        And request testData.existingEmailUser
        When method POST
        Then status 400
        And match response.message == "Este email já está sendo usado"
    
    @negative
    Scenario: Error al intentar registrar un usuario enviando el campo nombre vacío
        And request { nome: "", email: '#(testData.normalUser.email)', password: 'password123', administrador: 'true' }
        When method POST
        Then status 400
        And match response.nome == "nome não pode ficar em branco"

    @negative
    Scenario: Error al intentar registrar un usuario enviando el campo email vacío
        And request { nome: "Usuario de Prueba QA", email: '', password: 'password123', administrador: 'true' }
        When method POST
        Then status 400
        And match response.email == "email não pode ficar em branco"