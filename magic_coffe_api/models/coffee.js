const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Coffee = sequelize.define('Coffee', {
    coffee_id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    coffee_name: {
      type: DataTypes.STRING(50),
      allowNull: false,
    },
    image_url: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    volume_ml: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    is_hot: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
    },
    price: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: false,
    },
    point_value: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },
  }, {
    timestamps: false,
    tableName: 'coffees',
    indexes: [
      {
        name: 'idx_coffees_coffee_name',
        fields: ['coffee_name'],
      },
    ],
  });

  return Coffee;
};