/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_topsellsvc1");

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
        "autogeneratePattern": "",
        "hidden": false,
        "id": "_clone_kVhF",
        "max": 0,
        "min": 0,
        "name": "serviceName",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_services001",
        "hidden": false,
        "id": "_clone_OqMX",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "service_id",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "relation"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_GCBO",
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
        "id": "json2081462908",
        "maxSize": 1,
        "name": "total_quantity_sold",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
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
        "id": "number619353122",
        "max": null,
        "min": null,
        "name": "transaction_count",
        "onlyInt": true,
        "presentable": false,
        "required": false,
        "system": false,
        "type": "number"
      }
    ],
    "id": "pbc_topsellsvc1",
    "indexes": [],
    "listRule": "",
    "name": "vw_top_selling_services",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT\n  (ROW_NUMBER() OVER()) AS id,\n  ssi.serviceName,\n  ssi.service AS service_id,\n  s.branch,\n  DATE(s.created) AS sale_date,\n  SUM(ssi.quantity) AS total_quantity_sold,\n  SUM(ssi.subtotal) AS total_revenue,\n  COUNT(DISTINCT s.id) AS transaction_count\nFROM saleServiceItems ssi\nJOIN sales s ON ssi.sale = s.id\nWHERE (s.isDeleted = false OR s.isDeleted IS NULL)\n  AND s.status = 'completed'\nGROUP BY ssi.serviceName, ssi.service, s.branch, DATE(s.created)\nORDER BY total_revenue DESC",
    "viewRule": ""
  });

  return app.save(collection);
})
