require 'spec_helper'

module Spree
  describe ProductsHelper do
    include ProductsHelper
    include BaseHelper

    context "#product_price" do
      let!(:tax_category) { Factory(:tax_category) }
      let!(:product) { Factory(:product, :tax_category => tax_category) }

      it "shows a product's price" do
        Spree::Config.set :show_price_inc_vat => false
        product_price(product).should == "$19.99"
      end

      it "shows a product's price including tax" do
        product.stub :tax_category => tax_category
        tax_category.stub :effective_amount => BigDecimal.new(0.05, 2)
        Spree::Config.set :show_price_inc_vat => true
        product_price(product).should == "$20.99 (inc. VAT)"
      end

    end

    context "#variant_price_diff" do
      before do
        @product = Factory(:product)
        @variant = Factory(:variant, :product => @product)
      end

      it "should be correct positive value when variant is more than master" do
        @product.price = 10
        @variant.price = 15
        helper.variant_price_diff(@variant).should == "(Add: $5.00)"
      end

      it "should be nil when variant is same as master" do
        @product.price = 10
        @variant.price = 10
        helper.variant_price_diff(@variant).should be_nil
      end

      it "should be correct negative value when variant is less than master" do
        @product.price = 15
        @variant.price = 10
        helper.variant_price_diff(@variant).should == "(Subtract: $5.00)"
      end
    end
  end
end
