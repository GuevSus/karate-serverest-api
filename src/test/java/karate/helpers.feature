@ignore
Feature: Helpers - Utilidades para generación de datos de prueba

    Background:
        * def testData = call read('classpath:karate/helpers/testData.js')
        Given url baseUrl

    @CrearAdmin
    Scenario: Crear usuario administrador y retornar su ID
        Given path 'usuarios'
        And request testData.adminUser
        When method post
        Then status 201
        * def userId = response._id
    
    @CrearNormal
    Scenario: Crear usuario normal y retornar su ID
        Given path 'usuarios'
        And request testData.normalUser
        When method post
        Then status 201
        * def userId = response._id