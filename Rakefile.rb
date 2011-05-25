require 'rubygems'
require 'rake/testtask'

require './lib/ruby_diff/version'

desc "Generate the gemspec"
task "gemspec" do
  spec = Gem::Specification.new do |s|
    s.name            = "ruby-diff"
    s.version         = RubyDiff::VERSION
    s.platform        = Gem::Platform::RUBY
    s.summary         = "ruby-diff renders unified diffs into various forms."
    
    s.description     = %Q{ruby-diff renders unified diffs into various forms. The output is based on a callback object that's passed into the renderer}

    s.files           = `git ls-files`.split("\n") + %w(ruby-diff.gemspec)
    s.require_path    = 'lib'
    s.has_rdoc        = false
    s.extra_rdoc_files = ['README.txt']
    s.test_files      = Dir['test/{test,spec}_*.rb']
    
    s.authors          = ['Ketan Padegaonkar']
    s.email           = ['KetanPadegaonkar@gmail.com']
    s.homepage        = 'http://github.com/ketan/ruby-diff'
  end

  File.open("ruby-diff.gemspec", "w") { |f| f << spec.to_ruby }
end

desc "Generate the gem"
task :gem => ["gemspec"] do
  rm_rf 'pkg'
  sh "gem build ruby-diff.gemspec"
  mkdir 'pkg'
  mv "ruby-diff-#{Diff::Display::VERSION::STRING}.gem", "pkg"
end

task :test do
  Rake::TestTask.new do |t|
     t.libs << "test"
     t.test_files = FileList['test/**/*_test.rb']
     t.verbose = true
   end
end

task :default => :test
