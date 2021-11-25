@RickandMorty
Feature: Teste de API utilizando a API do Rick and Morty

Background: background a ser executado antes do teste
    * url 'https://rickandmortyapi.com/api'

Scenario: Testando a conexão com servidor e se tem quantidade esperada de retorno
    Given path '/character'
    When method get
    Then status 200
    And match $.info.count == 826

Scenario Outline: Testando se alguns pesonagens estão vivos e sua especie
    Given path '/character/' + <id>
    When method get
    Then match $.name == <name>
    And match $.status == <status>
    And match $.species == <especie>

    Examples: Examplos a serem testados
    |id         |name           |status         |especie         |
    |24         |"Armagheadon"  |"Alive"        |"Alien"         |
    |11         |"Albert Einstein"|"Alive"      |"Human"         |
    |234        |"Morty Smith"    |"Dead"       |"Human"         |
    |221        |"Melissa"        |"Alive"      |"Mythological Creature"    |
    |666        |"Squeeb"         |"Alive"      |"Human"         |
    # O id 11 é esperado erro, pois Albert Einstein está morto
    # O id 666 é esperado erro, pois a especie é Humanoid 

Scenario: Testando os tipos de dados do schema dos dados e o tipo de localização
    Given path '/location/3'
    When method get
    Then match $ contains {id: '#number',  name: '#string', type: '#string', dimension: '#string',residents: '#array', url: '#string', created: '#string'}
    And match $.name == "Citadel of Ricks"
    And match $.type == "Space station"
    And match $.dimension == "23"
    # é esperado erro na ultima comparação, onde a dimension == "unknown"

Scenario: Conferindo se API responde a busca de multiplos episodios
    Given path '/episode/1,2,35,12'
    When method get
    Then match $ ==  '#[4]'

Scenario Outline: Testando a busca de multiplos persogens com filtros
    Given path '/character/?name=' + <nome> + '&status=' + <status>
    When method get
    Then status 200
    And print response
    Examples: Usando 3 personagens como filtro
    |nome       |status         |
    |"rick"     |"alive"        |
    |"morty"    |"dead"         |
    |"birdperson"|"alive"       |


Scenario: Testando retorno da API ao encontrar numa request não existente
    Given path '/episode/666'
    When method get
    Then status 404
    And match response.error == "Episode not found"
