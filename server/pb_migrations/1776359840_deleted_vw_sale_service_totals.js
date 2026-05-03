/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_384506597");

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
        "id": "_clone_qqUD",
        "max": 0,
        "min": 0,
        "name": "receiptNumber",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2358601297",
        "hidden": false,
        "id": "_clone_Ade1",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "branch",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "relation"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "_clone_M1zH",
        "max": 0,
        "min": 0,
        "name": "customerName",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "_clone_8Vzf",
        "maxSelect": 1,
        "name": "orderStatus",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "select",
        "values": [
          "pending",
          "processing",
          "ready",
          "pickedUp"
        ]
      },
      {
        "hidden": false,
        "id": "_clone_jjvg",
        "name": "postedDate",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "_clone_uIqr",
        "name": "created",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "_clone_pjPJ",
        "name": "updated",
        "onCreate": true,
        "onUpdate": true,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "_clone_l0O4",
        "max": "",
        "min": "",
        "name": "processedDate",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "hidden": false,
        "id": "json758605309",
        "maxSize": 1,
        "name": "effectivePostedDate",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      },
      {
        "hidden": false,
        "id": "json3015788993",
        "maxSize": 1,
        "name": "serviceTotalAmount",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "json"
      }
    ],
    "id": "pbc_384506597",
    "indexes": [],
    "listRule": "",
    "name": "vw_sale_service_totals",
    "system": false,
    "type": "view",
    "updateRule": null,
    "viewQuery": "SELECT s.id, s.receiptNumber, s.branch, s.customerName, s.orderStatus, s.postedDate, s.created, s.updated, s.processedDate, COALESCE(s.postedDate, s.created) AS effectivePostedDate, COALESCE(SUM(si.subtotal), 0) AS serviceTotalAmount FROM sales s LEFT JOIN saleServiceItems si ON si.sale = s.id WHERE s.orderStatus IN (\"ready\", \"pickedUp\") GROUP BY s.id",
    "viewRule": ""
  });

  return app.save(collection);
})
