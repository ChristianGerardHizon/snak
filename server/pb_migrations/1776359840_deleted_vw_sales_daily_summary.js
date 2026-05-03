/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3432702729");

  return app.delete(collection);
}, (app) => {
  const collection = new Collection({
    "createRule": null,
    "deleteRule": null,
    "fields": [
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text3208210256",
        "max": 0,
        "min": 0,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "json382747551",
        "maxSize": 1,
        "name": "sale_date",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "_clone_ivdN",
        "maxSelect": 1,
        "name": "paymentMethod",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "select",
        "values": [
          "cash",
          "gcash",
          "card",
          "bankTransfer",
          "check"
        ]
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_AM69",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "branch",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "hidden": false,
        "id": "number619353122",
        "max": null,
        "min": null,
        "name": "transaction_count",
        "onlyInt": true,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "json487443959",
        "maxSize": 1,
        "name": "total_revenue",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json3227388031",
        "maxSize": 1,
        "name": "avg_transaction_value",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      }
    ],
    "id": "pbc_3432702729",
    "indexes": [],
    "listRule": "",
    "name": "vw_sales_daily_summary",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "\n    SELECT\n      (ROW_NUMBER() OVER()) AS id,\n      DATE(s.created) AS sale_date,\n      p.paymentMethod,\n      s.branch,\n      COUNT(DISTINCT s.id) AS transaction_count,\n      SUM(p.amount) AS total_revenue,\n      AVG(p.amount) AS avg_transaction_value\n    FROM sales s\n    LEFT JOIN payments p ON s.id = p.sale\n    WHERE (s.isDeleted = false OR s.isDeleted IS NULL)\n      AND s.status != 'voided'\n    GROUP BY DATE(s.created), p.paymentMethod, s.branch\n    ORDER BY sale_date DESC\n  ",
    "viewRule": ""
  });

  return app.save(collection);
})
