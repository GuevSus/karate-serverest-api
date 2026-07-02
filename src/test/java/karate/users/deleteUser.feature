Feature: DELETE /usuarios/{_id} - Eliminar usuarios del sistema

    Background:
        * url baseUrl
        * path 'usuarios'
        * def testData = call read('classpath:karate/helpers/testData.js')

    @smoke @happy-path
    Scenario: Eliminar un usuario existente de forma exitosa
        * def created = call read('classpath:karate/helpers.feature@CrearAdmin')
        * def userId = created.userId

        And path userId
        When method DELETE
        Then status 200
        And match response.message == "Registro excluído com sucesso"

    @negative
    Scenario: Intentar eliminar un usuario utilizando un ID inexistente
        And path testData.noExistentId
        When method DELETE
        Then status 200
        And match response.message == "Nenhum registro excluído"