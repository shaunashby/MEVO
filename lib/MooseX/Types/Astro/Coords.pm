package MooseX::Types::Astro::Coords;
use Moose::Util::TypeConstraints;

subtype 'RAValue'
    => as 'Num'
    => where { $_ >= 0 && $_ <= 360 }
    => message { "RA coordinates must be in the range 0,360." };

subtype 'DECValue'
    => as 'Num'
    => where { $_ >= -90 && $_ <= 90 }
    => message { "DEC coordinates must be in the range -90,90." };

1;

__END__
