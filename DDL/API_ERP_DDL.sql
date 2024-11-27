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







