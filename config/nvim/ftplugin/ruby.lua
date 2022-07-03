local has_cmp, cmp = pcall(require, 'cmp')

if has_cmp then
  local has_rails_fixture_types, rails_fixture_types = pcall(require, 'wassim.cmp.rails_fixture_types')
  if has_rails_fixture_types then
    rails_fixture_types.setup()
  end

  local has_rails_fixture_names, rails_fixture_names = pcall(require, 'wassim.cmp.rails_fixture_names')
  if has_rails_fixture_names then
    rails_fixture_names.setup()
  end
end
