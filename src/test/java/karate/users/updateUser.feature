Feature: PUT /usuarios/{id} - Actualizar información de usuarios

    Background:
        * url baseUrl
        * path 'usuarios'
        * def testData = call read('classpath:karate/helpers/testData.js')

    @smoke @happy-path
    Scenario: Actualizar los datos de un usuario existente exitosamente
        * def created = call read('classpath:karate/helpers.feature@CrearAdmin')
        * def userId = created.userId

        And path userId
        And request testData.updatedUser
        When method PUT
        Then status 200
        And match response.message == "Registro alterado com sucesso"

    @happy-path
    Scenario: Registrar nuevo usuario mediante PUT utilizando un ID inexistente 
        Given path testData.noExistentId
        And request testData.normalUser
        When method PUT
        Then status 201
        And match response.message == "Cadastro realizado com sucesso"

    @negative
    Scenario: Error al intentar actualizar un usuario con un email que ya está en uso
        * def created = call read('classpath:karate/helpers.feature@CrearNormal')
        * def userId = created.userId

        And path userId
        And request testData.existingEmailUser
        When method PUT
        Then status 400
        And match response.message == "Este email já está sendo usado"