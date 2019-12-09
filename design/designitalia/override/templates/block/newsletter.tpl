<div class="Grid u-background-80 u-padding-all-xxl">
  <div class="Grid-cell u-sizeFull">
    <div class="u-padding-all-xl  u-layoutCenter u-textCenter u-layout-prose" style="max-width: 32em !important;">
      <h3 class="u-text-h3 u-color-white">{$block.name|wash()}</strong></h3>

      <form class="Form" action="{'newsletter/subscribe'|ezurl(no)}" method="get">
        <div class="Form-field Form-field--withPlaceholder Grid u-background-white u-color-grey-30 u-borderRadius-s u-borderShadow-m">
          <button class="Grid-cell u-sizeFit Icon-mail u-color-grey-40 u-text-r-m u-padding-all-s u-textWeight-400" role="presentation" aria-hidden="true">
          </button>
          <input class="Form-input Form-input--ultraLean Grid-cell u-sizeFill u-text-r-s u-color-black u-text-r-xs u-borderHideFocus" required="required" id="newsletter" name="email" type="email">
          <label class="Form-label u-color-grey-40 u-padding-left-xxl" for="newsletter">
            <span class="u-hidden u-md-inline u-lg-inline">{'Email'|i18n('design/standard/user/register')}</span>
          </label>
          <button type="submit" class="Grid-cell u-sizeFit u-background-teal-30 u-color-white u-textWeight-600 u-padding-r-left u-padding-r-right u-textUppercase u-borderRadius-s">
            {'Sign Up'|i18n('design/standard/user','Button')}  
          </button>
        </div>
      </form>

    </div>
  </div>
</div>
