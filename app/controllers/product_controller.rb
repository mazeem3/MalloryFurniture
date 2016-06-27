require 'csv'
class ProductController < ApplicationController
    class Product
        attr_accessor :pid, :item, :description, :price, :condition,
                      :condition, :dimension_w, :dimension_l, :dimension_h, :img_file,
                      :quantity, :category, :clearance
    end

    def list
        @products = in_stock
    end

    def show
        products = discount
        @product = products.find { |p| p.pid == params[:pid] }
    end


    def fetch_products
        products = []

        CSV.foreach("#{Rails.root}/data-import/mf_inventory.csv", headers: true) do |row|
            product_hash = row.to_hash
            product = Product.new
            product.pid = product_hash['pid']
            product.item = product_hash['item']
            product.description = product_hash['description']
            product.price = product_hash['price'].to_f
            product.condition = product_hash['condition'].to_s
            product.dimension_w = product_hash['dimension_w']
            product.dimension_l = product_hash['dimension_l']
            product.dimension_h = product_hash['dimension_h']
            product.img_file = product_hash['img_file']
            product.quantity = product_hash['quantity'].to_i
            product.category = product_hash['category']


            products << product
        end

        products
    end

    def in_stock
      stocked = []
      product = discount
      product.each do |product|
        if product.quantity > 0
          stocked << product
      end

      end
    end

    def discount
      product = fetch_products
      product.each do |product|
        if product.condition == "good"
          product.price = product.price*0.9
          product.clearance = "Items on clearance"
        elsif product.condition == "average"
          product.price = product.price*0.8
          product.clearance = "Items on clearance"

        else
        end
      end
    end


end
