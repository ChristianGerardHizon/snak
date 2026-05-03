/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_payments001");

  return app.delete(collection);
}, (app) => {
  const collection = new Collection({
    "createRule": "",
    "deleteRule": "",
    "fields": [
      {
        "autogeneratePattern": "[a-z0-9]{15}",
        "hidden": false,
        "id": "text3208210256",
        "max": 15,
        "min": 15,
        "name": "id",
        "pattern": "^[a-z0-9]+$",
        "presentable": false,
        "primaryKey": true,
        "required": true,
        "system": true,
        "type": "text"
      },
      {
        "cascadeDelete": false,
        "collectionId": "pbc_2697449135",
        "hidden": false,
        "id": "relation_payment_sale",
        "maxSelect": 1,
        "minSelect": 0,
        "name": "sale",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "relation"
      },
      {
        "hidden": false,
        "id": "number_payment_amount",
        "max": null,
        "min": 0,
        "name": "amount",
        "onlyInt": false,
        "presentable": false,
        "required": true,
        "system": false,
        "type": "number"
      },
      {
        "hidden": false,
        "id": "select_payment_method",
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
        "hidden": false,
        "id": "select_payment_type",
        "maxSelect": 1,
        "name": "type",
        "presentable": false,
        "required": true,
        "system": false,
        "type": "select",
        "values": [
          "payment",
          "deposit",
          "refund"
        ]
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text_payment_ref",
        "max": 0,
        "min": 0,
        "name": "paymentRef",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "file_payment_proof",
        "maxSelect": 1,
        "maxSize": 5242880,
        "mimeTypes": [
          "image/jpeg",
          "image/png",
          "image/webp"
        ],
        "name": "paymentProof",
        "presentable": false,
        "protected": false,
        "required": false,
        "system": false,
        "thumbs": [
          "100x100"
        ],
        "type": "file"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text_payment_notes",
        "max": 0,
        "min": 0,
        "name": "notes",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      },
      {
        "hidden": false,
        "id": "autodate2990389176",
        "name": "created",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "autodate3332085495",
        "name": "updated",
        "onCreate": true,
        "onUpdate": true,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "autodate_postedDate_payments",
        "name": "postedDate",
        "onCreate": true,
        "onUpdate": false,
        "presentable": false,
        "system": false,
        "type": "autodate"
      },
      {
        "hidden": false,
        "id": "bool_payment_isVoided",
        "name": "isVoided",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "bool"
      },
      {
        "hidden": false,
        "id": "date_payment_voidedAt",
        "max": "",
        "min": "",
        "name": "voidedAt",
        "presentable": false,
        "required": false,
        "system": false,
        "type": "date"
      },
      {
        "autogeneratePattern": "",
        "hidden": false,
        "id": "text_payment_voidReason",
        "max": 0,
        "min": 0,
        "name": "voidReason",
        "pattern": "",
        "presentable": false,
        "primaryKey": false,
        "required": false,
        "system": false,
        "type": "text"
      }
    ],
    "id": "pbc_payments001",
    "indexes": [
      "CREATE INDEX `idx_payments_sale` ON `payments` (`sale`)"
    ],
    "listRule": "",
    "name": "payments",
    "system": false,
    "type": "base",
    "updateRule": "",
    "viewRule": ""
  });

  return app.save(collection);
})
