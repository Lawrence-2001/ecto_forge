defmodule EctoForge.Extension.Get.Pagination do
  use EctoForge.CreateExtension.Get

  def after_query_add_extension_to_get(_module, _mode, result, attrs) do
    {result, attrs}
  end
end
