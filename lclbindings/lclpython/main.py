import lclaplication
import unit1
app=lclaplication.Application()
lfmfile='unit2.lfm'
form1=app.CreateForm(unit1.TForm1,lfmfile)
x=form1.Button1.Width
form1.Button1.Width=10
form1.Button1.setOnClick(form1.onlic)
app.Run()
