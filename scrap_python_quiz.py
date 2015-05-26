import mechanize
from bs4 import BeautifulSoup

br = mechanize.Browser()
br.open('http://www.mypythonquiz.com/list.php')

count = 0
fh = open("Python_Test.txt", "w")

for l in br.links(url_regex='question.php', text_regex="\d+: "):
    url = l.url
    count += 1
    print "Question No.", count
    print "URL:", url

    try:
        br_qn = mechanize.Browser()
        br_qn.open('http://www.mypythonquiz.com/' + url)
        html = br_qn.response().read()
        soup = BeautifulSoup(html)
        trs = soup.find_all("tr")
        tr = trs.pop(0)
        tr_text = tr.get_text()
        fh.write(tr_text + "\n")
        print tr_text
        i = 97
        check_answer = True
        for tr in trs:
            correct = False
            answer_option = chr(i)
            if check_answer is True:
                br_ans = mechanize.Browser()
                br_ans.open('http://www.mypythonquiz.com/' + url + '&answer=' + answer_option)
                html_ans = br_ans.response().read()

                if html_ans.find('incorrect') < 0:
                    print "Correct Answer -- ",
                    check_answer = False
                    correct = True
                else:
                    pass

            tr_text = tr.get_text().rstrip()
            fh.write(answer_option + ". " + tr_text.encode('ascii', 'ignore'))
            if correct is True:
                fh.write(" -- Correct Answer")
            fh.write("\n")

            print answer_option + ".", tr_text

            i += 1

        fh.write("\n*************************************************************\n")
    except:
        raise

fh.close()
