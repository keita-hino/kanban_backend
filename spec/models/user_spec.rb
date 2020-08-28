# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  context 'validation' do
    subject { user.validate }

    context 'last_name(姓)' do
      it '必須になっていること' do
        user.last_name = nil
        is_expected.to be_falsey
      end
      it '21文字以上は入力不可になっていること' do
        user.last_name = 'a' * 21
        is_expected.to be_falsey
      end
    end
    context 'first_name(名)' do
      it '必須になっていること' do
        user.first_name = nil
        is_expected.to be_falsey
      end
      it '21文字以上は入力不可になっていること' do
        user.first_name = 'a' * 21
        is_expected.to be_falsey
      end
    end
    context 'email(メールアドレス)' do
      it '必須になっていること' do
        user.email = nil
        is_expected.to be_falsey
      end
      it '257文字以上は入力不可になっていること' do
        # ドメイン入りで257字にする
        dammy_address = '@example.com'.rjust(257, 'a')
        user.email = dammy_address
        is_expected.to be_falsey
      end
    end
  end
end
