require 'pry'

namespace :exercises do
  desc 'Load exercises and questions from .yml files in lib/exercises'
  task :load, [:file] => [:environment] do |t, args|
    exercise_files = Dir["lib/exercises/#{(args[:file] || '*') + '.yml'}"]

    exercise_files.each do |exercise_file|
      exercise_hash = YAML.load(File.read(exercise_file))
      exercise_from_hash(exercise_hash)
    end
  end
end

def exercise_from_hash(ex_hash)
  ex = Exercise.find_or_initialize_by(shortname: ex_hash['shortname'])
  ex.longname = ex_hash['longname']
  ex.logo = ex_hash['logo']
  ex.description = ex_hash['description']
  ex.category = ex_hash['category']
  ex.sub_description = ex_hash['sub_description']

  ex.save!

  ex_hash['questions'].each do |q|
    new_q            = ex.parent_questions.find_or_initialize_by(position: q['position'])
    new_q.position   = q['position']
    new_q.text       = q['text']
    new_q.answerable = q.fetch('answerable', true)
    new_q.comment    = q['comment']
    new_q.style      = q['style']

    add_answers(new_q, q) if new_q.multiple_choice?
    new_q.save!

    q.fetch('children', []).each do |child|
      new_child             = new_q.children.find_or_initialize_by(position: child['position'])
      new_child.exercise    = ex
      new_child.position    = child['position']
      new_child.text        = child['text']
      new_child.style       = child['style']

      add_answers(new_child, child) if new_child.multiple_choice?
      new_child.save!
    end
  end

  ex.save!
end

def add_answers(question, data)
  data['answer_choices'].each do |answer_choice|
    ac      = question.answer_choices.find_or_initialize_by(position: answer_choice['position'])
    ac.text = answer_choice['text']

    ac.save!
  end
end
