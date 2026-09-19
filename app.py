from flask import Flask, render_template, request
import subprocess
import os
import glob

app = Flask(__name__)


# Find Rscript automatically
def find_rscript():

    paths = [
        r"C:\Program Files\R\*\bin\Rscript.exe",
        r"C:\Program Files (x86)\R\*\bin\Rscript.exe",
        r"C:\Users\*\AppData\Local\Programs\R\*\bin\Rscript.exe"
    ]

    for path in paths:
        files = glob.glob(path)

        if files:
            return files[-1]

    return None


@app.route("/", methods=["GET", "POST"])
def home():

    result = ""

    if request.method == "POST":

        age = request.form["age"]
        income = request.form["income"]
        loan = request.form["loan"]
        credit = request.form["credit"]
        employment = request.form["employment"]
        existing = request.form["existing"]

        # Find Rscript
        rscript = find_rscript()

        if rscript is None:
            result = """
            Rscript was not found on this computer.
            Please check that R is installed.
            """
            return render_template("index.html", result=result)

        # Find predict.R
        r_file = os.path.abspath("predict.R")

        command = [
            rscript,
            r_file,
            age,
            income,
            loan,
            credit,
            employment,
            existing
        ]

        try:

            output = subprocess.run(
                command,
                capture_output=True,
                text=True
            )

            if output.returncode != 0:

                result = "R Error:\n" + output.stderr

            else:

                result = output.stdout

        except Exception as e:

            result = "Error: " + str(e)

    return render_template(
        "index.html",
        result=result
    )


if __name__ == "__main__":
    app.run(debug=True)