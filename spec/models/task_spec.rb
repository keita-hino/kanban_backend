require 'rails_helper'


RSpec.describe Task do
  let(:task) { create(:task) }

  context 'バリデーション' do
    context 'name(タスク名)' do
      it '必須になっていること' do
        task.name = nil
        task.valid?
        expect(task).to be_invalid
      end
      it '101文字以上は入力不可になっていること' do
        task.name = 'a' * 101
        task.valid?
        expect(task).to be_invalid
      end
    end
    context 'datail(詳細)' do
      it '201文字以上は入力不可になっていること' do
        task.detail = 'a' * 201
        task.valid?
        expect(task).to be_invalid
      end
    end
  end
end