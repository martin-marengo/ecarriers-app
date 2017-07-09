require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def valid_category
    Category.new(
        name: 'Electrodomésticos',
        code_name: 'code',
        description: 'Cualquier cosa'
    )
  end

  TOO_LONG_DESCRIPTION = 'Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa
                      Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa
                      Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa Cualquier cosa
                      Cualquier cosa Cualquier cosa Cualquier cosa'

  test 'Valid category' do
    category = valid_category

    assert_equal true, category.save
  end

  test 'Valid default values' do
    category = valid_category

    assert_equal true, category.are_measures_required?
    assert_equal true, category.is_weight_required?
  end

  test 'Category with long description' do
    category = Category.new(
        name: 'Electrodomésticos',
        description: TOO_LONG_DESCRIPTION,
        code_name: 'code_name'
    )

    assert_equal true, category.save
  end

  test 'Empty category' do
    category = Category.new
    
    assert_equal false, category.save
    assert_equal 3, category.errors.count
    assert_equal true, category.errors[:name].any?
    assert_equal true, category.errors[:code_name].any?
    assert_equal true, category.errors[:description].any?
  end

  test 'Category with parent' do
    category = Category.new(
        name: 'Electrodomésticos',
        description: 'Cualquier cosa',
        code_name: 'appliances',
        parent_category: categories(:all_requested)
    )

    assert_equal true, category.save
    assert_equal true, category.parent_category.valid?
  end

  test 'Category with children' do
    category = valid_category
    subcategory1 = categories(:all_requested)
    subcategory2 = categories(:nothing_requested)
    subcategory1.parent_category = category
    subcategory2.parent_category = category

    assert_equal true, subcategory1.save
    assert_equal true, subcategory2.save
    assert_equal true, category.save
    assert_equal 2, category.categories.count
  end

  test 'Category without parent and children' do
    category = valid_category

    assert_equal true, category.save
    assert_nil category.parent_category
    assert_equal 0, category.categories.count
  end
end
