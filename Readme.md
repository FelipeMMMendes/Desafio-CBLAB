## Contexto do código no repositório

Para resolver algumas etapas de ambos os desafios, eu subi um container do docker para que tivesse um ambiente com o airflow.

Ao avaliar esse relatório, se tiver interesse em ver o código em ação, siga os seguintes passos:

1º - Instale o docker engine no computador
https://docs.docker.com/desktop/setup/install/windows-install/

2º - Clone o repositório e abra um terminal nele. Após isso, use esse comando:

```
docker compose up -d
```

Se der erro, tente o comando abaixo antes, depois repita o segundo passo:
```
docker compose up --build -d
```
Se correr tudo bem, você terá subido um conjunto de contêineres com airflow e alguns bancos de dados.  

3º - Acesse esse link:

http://localhost:25550/

O usuário é **airflow** e a senha é **airflow**.

4º - Rode a DAG no airflow

5º - Se a DAG rodar sem erros, ela terá criado uma pasta temporária, extraido o arquivo JSON e inserido-o nela. 

Eu queria ter feito um sistema que raspasse os dados do arquivo e inserisse eles no postgres, mas, por questão do tempo, não consegui.

### Desafio 1

**Descreva o esquema JSON representado abaixo:** 

```
{
    "curUTC": "2024-05-05T06:06:06",
    "locRef": "99 CB CB",
    "guestChecks": [
        {
            "guestCheckId": 1122334455,
            "chkNum": 1234,
            "opnBusDt": "2024-01-01",
            "opnUTC": "2024-01-01T09:09:09",
            "opnLcl": "2024-01-01T06:09:09",
            "clsdBusDt": "2024-01-01",
            "clsdUTC": "2024-01-01T12:12:12",
            "clsdLcl": "2024-01-01T09:12:12",
            "lastTransUTC": "2024-01-01T12:12:12",
            "lastTransLcl": "2024-01-01T09:12:12",
            "lastUpdatedUTC": "2024-01-01T13:13:13",
            "lastUpdatedLcl": "2024-01-01T10:13:13",
            "clsdFlag": true,
            "gstCnt": 1,
            "subTtl": 109.9,
            "nonTxblSlsTtl": null,
            "chkTtl": 109.9,
            "dscTtl": -10,
            "payTtl": 109.9,
            "balDueTtl": null,
            "rvcNum": 101,
            "otNum": 1,
            "ocNum": null,
            "tblNum": 1,
            "tblName": "90",
            "empNum": 55555,
            "numSrvcRd": 3,
            "numChkPrntd": 2,
            "taxes": [
                {
                    "taxNum": 28,
                    "txblSlsTtl": 119.9,
                    "taxCollTtl": 20.81,
                    "taxRate": 21,
                    "type": 3
                }
            ],
            "detailLines": [
                {
                    "guestCheckLineItemId": 9988776655,
                    "rvcNum": 123,
                    "dtlOtNum": 1,
                    "dtlOcNum": null,
                    "lineNum": 1,
                    "dtlId": 1,
                    "detailUTC": "2024-01-01T09:09:09",
                    "detailLcl": "2024-01-01T06:09:09",
                    "lastUpdateUTC": "2024-11-01T10:10:10",
                    "lastUpdateLcl": "2024-01-01T07:10:10",
                    "busDt": "2024-01-01",
                    "wsNum": 7,
                    "dspTtl": 119.9,
                    "dspQty": 1,
                    "aggTtl": 119.9,
                    "aggQty": 1,
                    "chkEmpId": 10454318,
                    "chkEmpNum": 81001,
                    "svcRndNum": 1,
                    "seatNum": 1,
                    "menuItem": {
                        "miNum": 6042,
                        "modFlag": false,
                        "inclTax": 20.809091,
                        "activeTaxes": "28",
                        "prcLvl": 3
                    }
                }
            ]
        }
    ]
}
```

**Resposta**
Conforme foi dito no contexto do desafio, esse JSON se trata da resposta de uma API que traz dados do pedido de um cliente com um único item. Observando a estrutura, temos nos primeiros blocos uma identificação da unidade do restaurante e do horário, em seguida temos a chave **"GuestChecks"** que contém detalhes sobre o pedido do cliente, acredito que os mais relevantes seriam (estou supondo pois não sei o real significado de cada chave): 
- **"guestCheckId"**: guarda o número identificador do pedido; 
- **"clsdLcl"**: guarda a data e o horário de fechamento do pedido;
- **"clsdFlag"**: guarda um indicador para se o pedido foi fechado ou não;
- **"payTtl"**: guarda o valor total que foi pago na transação;
- **"tblNum"**: guarda o número identificador da mesa em que o cliente estava;
- **"empNum"**: guarda o número identificador do funcionário responsável pelo pedido;

Dentro da chave **"GuestChecks"** temos a chave **"taxes"** que guarda dados sobre os impostos envolvidos naquela transação, acredito que todas as informações que ela guarda seriam relevantes para relatórios ou análises estatísticas, seguem os tipos de dados que ela guarda:

-  **"taxNum"**: guarda o número do imposto;
-  **"txblSlsTtl"**: guarda o total de vendas tributáveis;
-  **"taxCollTtl"**: guarda o total de impostos cobrados;
-  **"taxRate"**: guarda a porcentagem da taxa do imposto;
-  **"type"**: guarda o tipo de imposto;

Após a chave **"taxes"** temos a chave **"DetailLines"** que guarda informações mais precisas sobre os itens vendidos. Nela acredito que os atributos mais importantes são:

- **"guestCheckLineItemId"**: guarda o identificador único do item na transação;
- **"dtlId"**: guarda o identificador da linha de transação;
- **"dspTtl"**: guarda o valor total da linha de item;
- **"dspQty"**: guarda a quantidade do item envolvida na transação;
- **"aggTtl"**: guarda o total agregado do tiem envolvido na transação;
- **"chkEmpId"**: guarda o número identificador do funcionário responsável pelo item na transação;

Dentro da chave **"DetailLines"** temos outra chave que contém uma lista de objetos, trata-se da **"menuItem"**, que detalha o item do menu envolvido no pedido. Acredito que os valores mais nela importantes sejam:

- **"miNum"**: guarda o número do item no menu;
- **"inclTax"**: guarda o valor do importe do imposto incluído no preço do item;
- **"activeTaxes"**: guarda o número de impostos ativos no item;
- **"prcLvl"**: guarda o nível de preço do item;

**Transcreva o JSON para tabelas SQL. A implementação deve fazer sentido para
operações de restaurante.**

O arquivo SQL que montei (com auxilio do ChatGPT) é esse:

```
CREATE TABLE en_restaurante (
    loc_ref VARCHAR(10) PRIMARY KEY,  -- Código único que identifica a localização do restaurante
);

CREATE TABLE en_pedido (
    guest_check_id BIGINT PRIMARY KEY,  -- Identificador único do pedido
    loc_ref VARCHAR(10) NOT NULL,       -- Referência à localização (chave estrangeira para en_restaurantes)
    chk_num INT,                        -- Número do cheque
    opn_bus_dt DATE,                    -- Data de abertura do pedido
    opn_utc TIMESTAMP,                  -- Data e hora de abertura em UTC
    opn_lcl TIMESTAMP,                  -- Data e hora de abertura local
    clsd_bus_dt DATE,                   -- Data de fechamento do pedido
    clsd_utc TIMESTAMP,                 -- Data e hora de fechamento em UTC
    clsd_lcl TIMESTAMP,                 -- Data e hora de fechamento local
    last_trans_utc TIMESTAMP,           -- Última transação em UTC
    last_trans_lcl TIMESTAMP,           -- Última transação local
    last_updated_utc TIMESTAMP,         -- Última atualização em UTC
    last_updated_lcl TIMESTAMP,         -- Última atualização local
    clsd_flag BOOLEAN,                  -- Indicador de pedido fechado
    gst_cnt INT,                        -- Contagem de clientes
    sub_ttl NUMERIC(10, 2),             -- Subtotal
    non_txbl_sls_ttl NUMERIC(10, 2),    -- Total de vendas não tributáveis
    chk_ttl NUMERIC(10, 2),             -- Total do pedido
    dsc_ttl NUMERIC(10, 2),             -- Total de descontos
    pay_ttl NUMERIC(10, 2),             -- Total pago
    bal_due_ttl NUMERIC(10, 2),         -- Saldo devido
    rvc_num INT,                        -- Número de receita
    ot_num INT,                         -- Número de operação
    oc_num INT,                         -- Número de ocupação
    tbl_num INT,                        -- Número da mesa
    tbl_name VARCHAR(10),               -- Nome da mesa
    emp_num INT,                        -- Número do funcionário
    num_srvc_rd INT,                    -- Número de rodadas de serviço
    num_chk_prntd INT,                  -- Número de cheques impressos
    FOREIGN KEY (loc_ref) REFERENCES en_restaurantes(loc_ref)
);

CREATE TABLE en_imposto (
    tax_num INT PRIMARY KEY,      -- Identificador único do imposto
    tax_rate NUMERIC(5, 2) NOT NULL,  -- Taxa de imposto, chave secundária
    type INT                     -- Tipo de imposto
);

CREATE TABLE re_imp_pedido (
    guest_check_id BIGINT,       -- Chave estrangeira referenciando en_pedidos
    tax_num INT,                -- Chave estrangeira referenciando en_imposto
    txbl_sls_ttl NUMERIC(10, 2), -- Total de vendas tributáveis
    tax_coll_ttl NUMERIC(10, 2), -- Total de imposto coletado
    PRIMARY KEY (guest_check_id, tax_num),  -- Combinação única de pedido e imposto
    FOREIGN KEY (guest_check_id) REFERENCES en_pedidos(guest_check_id),
    FOREIGN KEY (tax_num) REFERENCES en_imposto(tax_num)
);

CREATE TABLE en_menu_item (
    mi_num INT PRIMARY KEY,      -- Identificador único do item de menu
    mod_flag BOOLEAN,            -- Indicador de modificação do item
    incl_tax NUMERIC(10, 6),     -- Valor do imposto incluído no preço
    active_taxes VARCHAR(10),    -- Identificação de impostos ativos aplicáveis
    prc_lvl INT                  -- Nível de preço do item
);

CREATE TABLE en_detail_lines (
    guest_check_line_item_id BIGINT PRIMARY KEY,  -- Identificador único da linha de detalhe
    rvc_num INT,                                  -- Número do ponto de venda
    dtl_ot_num INT,                               -- Número do detalhe do pedido (order type)
    dtl_oc_num INT,                               -- Número do detalhe do pedido (order cycle), pode ser nulo
    line_num INT,                                 -- Número da linha do pedido
    dtl_id INT,                                   -- ID do detalhe
    detail_utc TIMESTAMP,                         -- Data e hora UTC do detalhe
    detail_lcl TIMESTAMP,                         -- Data e hora local do detalhe
    last_update_utc TIMESTAMP,                    -- Última atualização em UTC
    last_update_lcl TIMESTAMP,                    -- Última atualização em local
    bus_dt DATE,                                  -- Data de negócio do detalhe
    ws_num INT,                                   -- Número do workstation onde foi realizado o pedido
    dsp_ttl NUMERIC(10, 2),                       -- Total exibido para o cliente
    agg_ttl NUMERIC(10, 2),                       -- Total agregado
    agg_qty INT,                                  -- Quantidade agregada
    chk_emp_id BIGINT,                            -- ID do funcionário relacionado ao pedido
    chk_emp_num INT,                              -- Número do funcionário relacionado ao pedido
    svc_rnd_num INT,                              -- Número do serviço (service round)
    seat_num INT                                  -- Número do assento
);

CREATE TABLE re_item_lines (
    guest_check_line_item_id BIGINT,
    mi_num BIGINT,
    dsp_qty INT,       -- Quantidade exibida do item para aquele pedido
    PRIMARY KEY (guest_check_line_item_id, mi_num),  -- Chave composta
    FOREIGN KEY (guest_check_line_item_id) REFERENCES en_detail_lines (guest_check_line_item_id),
    FOREIGN KEY (mi_num) REFERENCES en_menu_item (mi_num)
);
```
Podem ter feito melhorias no quesito da tipagem das variáveis, algumas delas podem acabar consumindo mais recursos do que o necessário. Uma possibilidade que eu consideraria seria a de usar um banco NoSQL aqui, visto que a estrutura desse JSON é compatível com um banco NoSQL com arquitetura voltada a documentos (como MongoDB), além de que foi dito no contexto do desafio:
"No exemplo fornecido, o objeto detailLines contém um menuItem. Ele também **pode**
conter instâncias de: ... ", nisso da a entender que a estrutura é flexível, já que esse objeto citado pode ou não conter instâncias de outras coisas, e por conta dessa estrutura que pode variar um pouco, um banco de dados NoSQL casaria com o problema.

Descreva a abordagem escolhida em detalhes. Justifique a escolha.

![MER](https://i.imgur.com/nsasrR2.png)

Acima está o modelo entidade relacionamento que representa a minha compreensão do JSON, no caso cada um das entidades tem muitas colunas, então no desenho coloquei somente as que auxiliam na identificação. Passando as tabelas:
- **EN_RESTAURANTE**: essa tabela guarda a identificação do restaurante, no JSON só temos a identificação da localidade, então usei ela como chave primária. Essa tabela vai ser interessante para as equipes de gestão conseguirem agrupar mais os dados a partir dos restaurantes.
- **EN_PEDIDO**: essa tabela vai guardar os pedidos, no caso ela vai ter uma relação de um com muitos com a **en_restaurante**, visto que um restaurante pode ter vários pedidos, mas um pedido só pode vir de um restaurante.
- **EN_IMPOSTO**: essa tabela guarda os detalhes dos impostos. Nesse caso eu acredito ser válido guardar os impostos em uma tabela separada por conta que existe um identificador deles, e como cada imposto tem uma taxa vinculada a ele, evitaria a repetição dos dados.
- **EN_DETAIL_LINES**: essa tabela é referente aos detalhes da linha do pagamento do pedido e traz informações como valor total do pedido, desconto no pedido, quantidade de item, localização da mesa, etc.
- **EN_MENU_ITEM**: essa tabela guarda informações sobre os itens disponíveis no restaurante. Achei interessante manter esses dados em uma tabela separada porque assim o facilita controle da gestão sobre os itens que estão disponíveis no restaurante.
- **RE_IMP_PEDIDO**: essa tabela é uma tabela de relacionamento para impostos e pedidos. Como um pedido pode ter vários impostos e um imposto pode estar em vários pedidos, ela faz-se necessária. Nesse sentido, essa tabela guarda o tipo de imposto e os valores que ele impacta.
- **RE_ITEM_LINES**: essa tabela é uma tabela de relacionamento para itens e linhas de pagamento, ela é necessária porque como não existe um identificador exclusivo para cada item de cada tipo (ex: cada camarão servido não possui um identificador exclusivo, mas sim um código que remete ao item camarão) um item pode estar em várias linhas de pagamento assim como as linhas de pagamento podem possuir vários itens.

### Desafio 2

1. **Porque armazenar as respostas das APIs?**

Eu armazenaria as respostas das APIs por dois motivos principais: **incluir os dados no meu ambiente e para dar mais velocidade de processamento.** Com os dados em meu ambiente, eu elimino algumas das variáveis externas ao meu projeto que possam impactar no meu fluxo de dados. Por exemplo, se eu não guardar esses retornos das APIs, vou ficar dependendo da infraestrutura delas, e se por algum acaso essas APIs forem derrubadas? Ficarei com o meu serviço indisponível por fatores externos ao meu controle. Também ao fazer essa inclusão das respostas no meu ambiente eu estou construindo um Data Lake. Agora indo para a questão da velocidade, é mais rápido eu acessar os arquivos localmente, do meu ambiente, do que fazer uma requisição e aguardar o retorno da API. Nesse sentido, armazenar as respostas das APIs é uma boa prática.

2. **Como você armazenaria os dados? Crie uma estrutura de pastas capaz de armazenar as respostas da API. Ela deve permitir manipulaçõe, verificações, buscas e pesquisas rápidas.**

Em um cenário de produção eu arquitetaria um Data Lake e armazenaria nele. Como os dados vão ser só extraídos e não transformados não há necessidade de um data warehouse nesse trecho, se fossemos além ai sim seria interessante inserir um data warehouse na jogada. Nesse sentido, implementei uma classe files_utils, que auxilia na manipulação de dados em um diretório.

3. **Considere que a resposta do endpoint getGuestChecks foi alterada, por exemplo, guestChecks.taxes foi renomeado para guestChecks.taxation. O que isso implicaria?**

Isso implicaria em um problema no meu fluxo de dados, pois eu vou estar informando no código que o arquivo que estamos esperando da API é o **guestChecks.taxes**, se ele receber um arquivo com outro nome, o código falha. Mas pra corrigir isso não seria muito difícil, um bom engenheiro de dados faria um código em que o nome do arquivo seria passado em um .env ou em algum único lugar do código todo, nesse sentido bastaria alterar o nome do arquivo nesse único lugar que isso iria refletir no fluxo de dados inteiro. 

