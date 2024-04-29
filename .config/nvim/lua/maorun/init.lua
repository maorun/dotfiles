package['rpc'] = nil
local c = require('rpc')

RPC = {
    product = function()
        c.CurlJob('http://localhost:3000/products/6554b8060774b7adfa951db2', {
            type = 'html',
            method = 'post',
            form = {
                id = '6554b8060774b7adfa951db2',
                name = 'marco',
                manufacturer = 'marco',
                ['category-id'] = '648ac3ceea26484790c91120',
                ['attribute-keys'] = '81b85194-093c-4064-9350-a17a34743730',
                ['attributes[81b85194-093c-4064-9350-a17a34743730]'] = 'foo',

            }
        })
    end,
    zins = function()
        c.CurlJob('http://localhost:3000/simulate', {
            type = 'json',
            method = 'post',
            form = {
                year = '2024',
                ['end'] = '2025',
                sparplanElements =
                '[{"start":"2024-01-01T00:00:00.000Z","einzahlung":24000,"type":"sparplan","simulation":{}},{"start":"2024-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2025-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2026-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2027-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2028-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2029-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2030-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2031-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2032-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2033-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2034-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2035-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2036-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2037-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2038-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2039-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}},{"start":"2040-01-01T00:00:00.000Z","einzahlung":200000,"type":"sparplan","simulation":{}}]',
                rendite = '0.05',
                steuerlast = '0.26375',
                simulationAnnual = 'yearly',
            },
        })
    end,
    deals = function()
        c.CurlJob('http://localhost:3000/deals', {
            type = 'json',
            query = {
                search = 'MagSafe',
                page = 1,
                _data = 'routes/deals._index',
            },
        })
    end,
}
