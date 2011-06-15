require 'saikuro_treemap'

namespace :metrics do
  desc 'generate ccn treemap'
  task :ccn_treemap do
    SaikuroTreemap.generate_treemap :code_dirs => ['lib', 'app/models']
    `open reports/saikuro_treemap.html`
  end
end