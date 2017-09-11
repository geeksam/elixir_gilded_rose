defmodule Item, do: defstruct name: nil, sell_in: nil, quality: nil

defmodule GildedRose do
  @sulfuras  "Sulfuras, Hand of Ragnaros"
  @aged_brie "Aged Brie"
  @backstage "Backstage passes to a TAFKAL80ETC concert"
  @conjured  "Conjured Mana Cake"

  def update_quality(items) do
    Enum.map( items, &update_item(&1) )
  end

  defp update_item(item) do
    item
    |> update_item_sell_in
    |> update_item_quality
    |> enforce_quality_constraints
  end

  defp update_item_sell_in( item = %Item{ name: @sulfuras } ) do
    item
  end
  defp update_item_sell_in( item = %Item{ sell_in: sell_in } ) do
    %{item | sell_in: item.sell_in - 1}
  end

  defp update_item_quality( item = %Item{ sell_in: sell_in } ) when sell_in < 0 do
    %{item | quality: item.quality + quality_modifier(item) * 2 }
  end
  defp update_item_quality( item = %Item{} ) do
    %{item | quality: item.quality + quality_modifier(item) }
  end

  defp quality_modifier( item = %Item{ name: @sulfuras} ),                                 do: 0
  defp quality_modifier( item = %Item{ name: @aged_brie } ),                               do: 1
  defp quality_modifier( item = %Item{ name: @backstage, sell_in: days } ) when days <  0, do: -item.quality
  defp quality_modifier( item = %Item{ name: @backstage, sell_in: days } ) when days <  5, do: 3
  defp quality_modifier( item = %Item{ name: @backstage, sell_in: days } ) when days < 10, do: 2
  defp quality_modifier( item = %Item{ name: @backstage } ),                               do: 1
  defp quality_modifier( item = %Item{ name: @conjured } ),                                do: -2
  defp quality_modifier( item = %Item{} ),                                                 do: -1

  defp enforce_quality_constraints(item = %Item{ name: @sulfuras } ),        do: item
  defp enforce_quality_constraints(item = %Item{ quality: q } ) when q > 50, do: %{ item | quality: 50 }
  defp enforce_quality_constraints(item = %Item{ quality: q } ) when q <  0, do: %{ item | quality:  0 }
  defp enforce_quality_constraints(item = %Item{} ),                         do: item
end
