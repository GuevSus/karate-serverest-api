Feature: GET /usuarios/{_id} - Buscar Usuario por ID

    Background:
        * url baseUrl
        * path 'usuarios'
        * def testData = call read('classpath:karate/helpers/testData.js')
        * def schemas = read('classpath:karate/users/schemas/userSchema.json')

    @smoke @happy-path
    Scenario: Buscar un usuario por ID único exitosamente
        * def created = call read('classpath:karate/helpers.feature@CrearAdmin')
        * def userId = created.userId

        And path userId
        When method GET
        Then status 200
        And match response._id == userId
        And match response == schemas.userObject

    @negative
    Scenario: Error al intentar buscar un usuario utilizando un ID inexistente
        And path testData.noExistentId
        When method GET
        Then status 400
        And match response.message == "Usuário não encontrado"