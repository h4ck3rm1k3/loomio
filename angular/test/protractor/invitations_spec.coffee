describe 'Invitations', ->
  page = require './helpers/page_helper.coffee'

  it 'sends default invitations to a couple of people', ->
    page.loadPath 'setup_new_group'
    page.click '.group-welcome-modal__close-button',
               '.members-card__invite-members-btn'
    page.fillIn '.invitation-form__email-addresses', 'Sam My <sammy@example.com>, pammy@example.com'
    page.click '.invitation-form__submit'
    page.expectFlash '2 invitations sent.'

  it 'disables send button when no valid email addresses present', ->
    page.loadPath 'setup_new_group'
    page.click '.group-welcome-modal__close-button',
               '.members-card__invite-members-btn'
    page.fillIn '.invitation-form__email-addresses', 'invalidemailaddress'
    page.expectDisabledElement '.invitation-form__submit'

  it 'sends custom invitation to a person', ->
    page.loadPath 'setup_new_group'
    page.click '.group-welcome-modal__close-button',
               '.members-card__invite-members-btn'
    page.fillIn '.invitation-form__email-addresses', 'dilly@example.com'
    page.click '.invitation-form__add-custom-message-link'
    page.fillIn '.invitation-form__custom-message', 'Hey friends, join the team.'
    page.click '.invitation-form__submit'
    page.expectFlash 'Invitation sent.'

  it 'has invitation link to share with the team', ->
    page.loadPath 'setup_new_group'
    page.click '.group-welcome-modal__close-button',
               '.members-card__invite-members-btn'
    page.expectInputValue '.invitation-form__shareable-link-field', '/invitations/'

  it 'displays an error if all invitees are existing group members', ->
    page.loadPath 'setup_new_group'
    page.click '.group-welcome-modal__close-button',
               '.members-card__invite-members-btn'
    page.fillIn '.invitation-form__email-addresses', 'patrick_swayze@example.com'
    page.click '.invitation-form__submit'
    page.expectText '.lmo-validation-error', "We didn't send invitations to the email addresses provided because they belong to people already in the group."

  it 'lets you add members from the parent to a subgroup', ->
    page.loadPath 'setup_group'
    page.click '.group-page-actions__button',
               '.group-page-actions__add-subgroup-link'

    page.fillIn '#group-name', 'subgroup for some'

    page.click '.group-form__submit-button',
               '.members-card__invite-members-btn',
               '.invitation-form__add-members',
               '.add-members-modal__list-item:first-of-type',
               '.add-members-modal__submit'

    page.expectFlash 'Jennifer Grey added to Subgroup'

  it 'preselects current group if form launched from start menu while viewing group or thread page', ->
    page.loadPath 'setup_dashboard'
    page.clickFirst '.thread-preview__link'
    page.click '.start-menu__start-button'
    page.click '.start-menu__invitePeople'
    page.expectText '.invitation-form__group-select', 'Dirty Dancing Shoes'
