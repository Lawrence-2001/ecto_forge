# EctoForge

## Motiviation

This module allows on-the-go editing of contexts, extensions, and providing basic work for the database with ecto. With this module you can add your own extensions for functions such as `find_all` `get_all` `get!` `find`

## Examle usage

### Create an instance and plug in the necessary extensions from the existing ones or use ready-made ones

```elixir
defmodule MyApp.EctoForgeInstanseBase do
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload, # By EctoForge Exstensions
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Pagination
    ],
    repo: MyApp.Repo
end
```

### After you can use

You will then be able to connect your instance to the model or reuse it in context

```elixir

 defmodule MyApp.UserModel do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "user" do
    field(:name, :string)
    # timestamps()
  end

  use MyApp.EctoForgeInstanseBase
  @doc false
  def changeset(emails_model \\ %__MODULE__{}, attrs) do
    emails_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
```

After connection, the basic functions for the model will appear in the modules `MyApp.UserModel`

### Or create your own context

```elixir
defmodule MyApp.Context.UserModel do
 use MyApp.EctoForgeInstanseBase, module_model: MyApp.UserModel
end
```

## What are extensions?

This is the basic control for the `find` `find_all` `get_all` `get!` `get_all`

### Extensions in action

You can use callback functions for processing. After the query and before the query to filter the data.

```elixir
 @doc """
 module MyApp.UserModel -> your own module
 mode -> :all or :one
 query -> handled query
 attrs -> attributes that fall
 """
  def before_query_add_extension_to_get(_module, _mode, query, attrs) do
  # module MyApp.UserModel

  {query, attrs} # must return query and modified attributes
  end
   @doc """
 module MyApp.UserModel -> your own module
 query -> handled query
 attrs -> attributes that fall
 """
  def after_query_add_extension_to_get(_module, _mode, result, attrs) do
  # module MyApp.UserModel

  {result, attrs} # must return result and modified attributes
  end
```

create your first extension using the module.

#### Example

```elixir
defmodule EctoForge.Extension.Get.Preload do
  @moduledoc """
  ## Use preload with your model
  ### Example
  MyApp.UserModel.find(preload: [:user])
  """
  alias EctoForge.Helpers.RepoBase.Utls
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, query, attrs) do
    preload_attrs = Utls.MapUtls.opts_to_map(attrs)
    attrs = Keyword.delete(attrs, :preload)

    if is_list(preload_attrs) do
      {preload(query, ^preload_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
```

## Callacks

on_created

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_forge` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_forge, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ecto_forge>.
