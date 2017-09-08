defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  def update_quality(items) do
    Enum.map( items, &( update_item(&1) ) )
  end

  defp update_item(item = %Item{name: "Sulfuras, Hand of Ragnaros"}) do
    item
  end

  defp update_item(item = %Item{name: "Aged Brie"}) do
    new_quality = item.quality + quality_modifier(item)
    new_quality = if( new_quality > 50, do: 50, else: new_quality )

    new_sell_in = item.sell_in - 1
    %{item | quality: new_quality, sell_in: new_sell_in}
  end

  defp quality_modifier( item = %Item{ name: "Aged Brie", sell_in: sell_in} ) when sell_in <= 0 do
    2
  end
  defp quality_modifier( item = %Item{name: "Aged Brie"} ) do
    1
  end

  defp update_item(item) do
    if item.name != "Backstage passes to a TAFKAL80ETC concert" do
      if item.quality > 0 do
        item = %{item | quality: item.quality - 1}
      end
    else
      if item.quality < 50 do
        item = %{item | quality: item.quality + 1}
        if item.name == "Backstage passes to a TAFKAL80ETC concert" do
          if item.sell_in < 11 do
            if item.quality < 50 do
              item = %{item | quality: item.quality + 1}
            end
          end
          if item.sell_in < 6 do
            if item.quality < 50 do
              item = %{item | quality: item.quality + 1}
            end
          end
        end
      end
    end
    item = %{item | sell_in: item.sell_in - 1}
    if item.sell_in < 0 do
      if item.name != "Backstage passes to a TAFKAL80ETC concert" do
        if item.quality > 0 do
          item = %{item | quality: item.quality - 1}
        end
      else
        item = %{item | quality: item.quality - item.quality}
      end
    end
    item
  end

end
