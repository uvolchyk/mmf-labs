import collections
import sys

ID, FORENAME, MIDDLENAME, SURNAME, DEPARTMENT = range(5)
User = collections.namedtuple("User", "id username forename middlename surname")

def process_line(line, usernames):
    fields = line.split(":")
    username = generate_username(fields, usernames)
    return User(fields[ID], username, fields[FORENAME], fields[MIDDLENAME], fields[SURNAME])

def generate_username(fields, usernames):
    username = (fields[FORENAME][0] + fields[MIDDLENAME][:1] +
                fields[SURNAME]).replace("-", "").replace("'", "")
    username = original_username = username[:8].lower()
    count = 1
    while username in usernames:
        username = "{0}{1}".format(original_username, count)
        count += 1
    usernames.add(username)
    return username

def print_users(users):
    namewidth = 17
    usernamewidth = 9
    page_height = 64
    titles = ("Name", "ID", "Username")

    print_title(titles, namewidth, usernamewidth)

    sorted_users = sorted(users)
    for lino, user_pair in enumerate(zip(sorted_users[::2], sorted_users[1::2]),
                                     start=1):
        if lino % page_height == 0:
            print("\f")
            print_title(titles, namewidth, usernamewidth)
        print((make_userline(users[user_pair[0]], namewidth, usernamewidth) + " " +
               make_userline(users[user_pair[1]], namewidth, usernamewidth)))

    if len(sorted_users) % 2 != 0:
        last_user = sorted_users[len(users) - 1]
        print((make_userline(users[last_user], namewidth, usernamewidth)))


def print_title(titles, namewidth, usernamewidth):
    print("{0:<{nw}} {1:^6} {2:^{uw}} {0:<{nw}} {1:^6} {2:^{uw}}".format(
        *titles, nw=namewidth, uw=usernamewidth))
    print("{0:-<{nw}} {0:-<6} {0:-<{uw}} {0:-<{nw}} {0:-<6} {0:-<{uw}}".format(
        "", nw=namewidth, uw=usernamewidth
    ))


def make_userline(user, namewidth, usernamewidth):
    fullname = user.surname + ", " + user.forename
    if user.middlename:
        fullname += " " + user.middlename[:1]
    return "{fn:.<{nw}.{nw}} ({u.id:^4}) {u.username:<{uw}}".format(
        fn=fullname, u=user, nw=namewidth, uw=usernamewidth)


def main():
    if len(sys.argv) == 1 or sys.argv[1] in ("-h", "--help"):
        print("usage: {0} file1 [file2 [... fileN]]".format(sys.argv[0]))
        sys.exit()

    usernames = set()
    users = {}
    for filename in sys.argv[1:]:
        for line in open(filename, encoding="utf8"):
            line = line.strip()
            if not line:
                continue
            user = process_line(line, usernames)
            users[(user.surname.lower(), user.forename.lower(), user.id)] = user

    print_users(users)

if __name__ == '__main__':
    main()
