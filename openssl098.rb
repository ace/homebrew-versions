require "formula"

class Openssl098 < Formula
  homepage "https://www.openssl.org"
  url "https://www.openssl.org/source/openssl-0.9.8zd.tar.gz"
  sha256 "59266dcfb0be0fbe6181edead044ac3edaf83bc58991f264dcf532b01d531ee3"

  keg_only :provided_by_osx

  def install
    args = %W[
      --prefix=#{prefix}
      --openssldir=#{etc}/openssl
      no-ssl2
      zlib-dynamic
      shared
    ]

    if MacOS.prefer_64_bit?
      args << "darwin64-x86_64-cc" << "enable-ec_nistp_64_gcc_128"
    else
      args << "darwin-i386-cc"
    end

    system "perl", "./Configure", *args

    ENV.deparallelize # Parallel compilation fails
    system "make"
    system "make", "test"
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end
end
