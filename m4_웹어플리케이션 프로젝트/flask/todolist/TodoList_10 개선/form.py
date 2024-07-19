from flask_wtf import FlaskForm
from wtforms import (
    StringField,
    PasswordField,
    TextAreaField,
    DateField,
    BooleanField,
    SubmitField,
    FileField,
    URLField
)
from wtforms.validators import DataRequired, Email, EqualTo, Optional


class TaskForm(FlaskForm):
    title = StringField("Title", validators=[DataRequired()])
    filter = StringField("filter",validators=[Optional()])
    contents = TextAreaField("Contents", validators=[DataRequired()])
    start_date = DateField("Start Date", validators=[DataRequired()])
    due_date = DateField("Due Date", validators=[DataRequired()])
    completion_date = DateField(
        "Completion Date", validators=[Optional()]
    )  # 새로운 필드
    file = FileField("File")
    link = URLField("URL")
    submit = SubmitField("Submit")


class LoginForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    password = PasswordField("Password", validators=[DataRequired()])
    submit = SubmitField("Submit")


class RegistrationForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    email = StringField("Email", validators=[DataRequired(), Email()])
    password = PasswordField("Password", validators=[DataRequired()])
    confirm_password = PasswordField(
        "Confirm Password", validators=[DataRequired(), EqualTo("password")]
    )
    submit = SubmitField("Submit")


class UserForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    email = StringField("Email", validators=[DataRequired(), Email()])
    password = PasswordField("Password", validators=[DataRequired()])
    confirm_password = PasswordField(
        "Confirm Password", validators=[DataRequired(), EqualTo("password")]
    )
    is_admin = BooleanField("Admin")
    submit = SubmitField("Submit")


class UpdateProfileForm(FlaskForm):
    username = StringField("Username", validators=[DataRequired()])
    email = StringField("Email", validators=[DataRequired(), Email()])
    password = PasswordField("New Password")
    confirm_password = PasswordField(
        "Confirm Password", validators=[EqualTo("password")]
    )
    submit = SubmitField("Submit")
