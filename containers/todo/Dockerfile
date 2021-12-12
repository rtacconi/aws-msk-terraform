FROM python:3

RUN curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64
RUN chmod +x /usr/local/bin/dbmate

WORKDIR /usr/src/app

COPY . .
RUN rm -rf .env
RUN pip install --no-cache-dir -r requirements.txt
RUN chmod +x ./entrypoint.sh

EXPOSE 5000

ENTRYPOINT [ "./entrypoint.sh" ]
