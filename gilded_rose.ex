defmodule Item do
  @fields name: nil, sell_in: nil, quality: nil
  defstruct @fields

  def fields, do: @fields
end

defmodule Item.Legendary, do: defstruct Item.fields
defmodule Item.Aged,      do: defstruct Item.fields
defmodule Item.Backstage, do: defstruct Item.fields
defmodule Item.Conjured,  do: defstruct Item.fields
defmodule Item.Normal,    do: defstruct Item.fields

defmodule GildedRose do
  def update_quality(items) do
    Enum.map( items, &update_item(&1) )
  end

  defp update_item(item) do
    item
    |> typecast
    |> update_item_sell_in
    |> update_item_quality
    |> enforce_quality_constraints
  end

  defp typecast( item = %Item{ name: "Sulfuras, Hand of Ragnaros" } ),                do: %{ item | __struct__: Item.Legendary }
  defp typecast( item = %Item{ name: "Aged Brie" } ),                                 do: %{ item | __struct__: Item.Aged      }
  defp typecast( item = %Item{ name: "Backstage passes to a TAFKAL80ETC concert" } ), do: %{ item | __struct__: Item.Backstage }
  defp typecast( item = %Item{ name: "Conjured Mana Cake" } ),                        do: %{ item | __struct__: Item.Conjured  }
  defp typecast( item = %Item{} ),                                                    do: %{ item | __struct__: Item.Normal    }

  defp update_item_sell_in( item = %Item.Legendary{} ) do
    item
  end
  defp update_item_sell_in( item = %{ sell_in: sell_in } ) do
    %{item | sell_in: item.sell_in - 1}
  end

  defp update_item_quality( item = %{ sell_in: sell_in } ) when sell_in < 0 do
    %{item | quality: item.quality + quality_modifier(item) * 2 }
  end
  defp update_item_quality( item = %{} ) do
    %{item | quality: item.quality + quality_modifier(item) }
  end

  defp quality_modifier( item = %Item.Legendary{} ),                               do: 0
  defp quality_modifier( item = %Item.Aged{} ),                                    do: 1
  defp quality_modifier( item = %Item.Backstage{ sell_in: days } ) when days <  0, do: -item.quality
  defp quality_modifier( item = %Item.Backstage{ sell_in: days } ) when days <  5, do: 3
  defp quality_modifier( item = %Item.Backstage{ sell_in: days } ) when days < 10, do: 2
  defp quality_modifier( item = %Item.Backstage{} ),                               do: 1
  defp quality_modifier( item = %Item.Conjured{} ),                                do: -2
  defp quality_modifier( item = %Item.Normal{} ),                                                 do: -1

  defp enforce_quality_constraints(item = %Item.Legendary{} ),           do: item
  defp enforce_quality_constraints(item = %{ quality: q } ) when q > 50, do: %{ item | quality: 50 }
  defp enforce_quality_constraints(item = %{ quality: q } ) when q <  0, do: %{ item | quality:  0 }
  defp enforce_quality_constraints(item = %{} ),                         do: item
end
