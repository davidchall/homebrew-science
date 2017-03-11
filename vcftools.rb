class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://github.com/vcftools/vcftools/archive/v0.1.14.tar.gz"
  sha256 "ba440584645e9901c1eeb6b769ccd828591f0575c73349072cde3efa77da6fdf"

  head "https://github.com/vcftools/vcftools.git"

  bottle do
    cellar :any
    sha256 "c23bd10a337957be077c646d09b8300dca5775108f00c6bfbffe6d21d7b24f57" => :yosemite
    sha256 "b5ef3582f162ed1a5be8eb93b1033d2bca429839842aad25c2dc36c6ec6dbe39" => :mavericks
    sha256 "3e55f4cdeeaa33e626076d05f0ded4633d295281acc78f5f05984648885415ee" => :mountain_lion
    sha256 "234317e7c4c761970c12f21229d103c15f04dadf3beaca319c786e0bdbb62f44" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib" => :run
  depends_on "homebrew/dupes/zlib" => :optional if OS.mac?
  depends_on "zlib" if OS.linux?

  def install
    args = ["--prefix=#{prefix}"]

    if build.with? "zlib" || OS.linux?
      zlib = Formula["zlib"]
      args << "LIB=-lz -L#{zlib.opt_lib} -I#{zlib.opt_include}"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    To use the Perl modules, make sure Vcf.pm, VcfStats.pm, and FaSlice.pm
    are included in your PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system "#{bin}/vcftools"
  end
end
