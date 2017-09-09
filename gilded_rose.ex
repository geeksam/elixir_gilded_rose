defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  def update_quality(items) do
    Enum.map( items, &( update_item(&1) ) )
  end

  defp update_item(item = %Item{ name: "Sulfuras, Hand of Ragnaros" }) do
    item
  end

  defp update_item(item = %Item{ name: "Aged Brie" }) do
    item
    |> update_item_quality
    |> cap_quality
    |> update_item_sell_in
  end

  defp update_item(item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert" }) do
    item = %{item | quality: item.quality + 1}
    if item.sell_in < 11 do
      item = %{item | quality: item.quality + 1}
    end
    if item.sell_in < 6 do
      item = %{item | quality: item.quality + 1}
    end
    if item.sell_in < 1 do
      item = %{item | quality: item.quality - item.quality}
    end

    item
    |> cap_quality
    |> update_item_sell_in
  end

  defp quality_modifier( item = %Item{ name: "Aged Brie", sell_in: sell_in} ) when sell_in <= 0 do ; 2 ; end
  defp quality_modifier( item = %Item{ name: "Aged Brie" } )                                    do ; 1 ; end

  defp update_item_quality(item) do
    modifier = quality_modifier(item)
    %{ item | quality: modifier + item.quality }
  end

  defp cap_quality(item = %Item{ quality: quality }) when quality > 50 do
    %{ item | quality: 50 }
  end
  defp cap_quality(item = %Item{}) do
    item
  end

  defp update_item_sell_in(item = %Item{}) do
    %{ item | sell_in: item.sell_in - 1 }
  end

  defp update_item(item) do
    if item.quality > 0 do
      item = %{ item | quality: item.quality - 1 }
    end
    item = %{item | sell_in: item.sell_in - 1}
    if item.sell_in < 0 do
      if item.quality > 0 do
        item = %{item | quality: item.quality - 1}
      end
    end
    item
  end

end
