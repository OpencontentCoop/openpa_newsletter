<h3>{$block.name|wash()}</h3>

<form action="{'newsletter/subscribe'|ezurl(no)}" method="get">
    <labelfor="newsletter">{'Email'|i18n('design/standard/user/register')}</label>
    <input required="required" id="newsletter" name="email" type="email">          
    <button type="submit">{'Sign Up'|i18n('design/standard/user','Button')}</button>
</form>
